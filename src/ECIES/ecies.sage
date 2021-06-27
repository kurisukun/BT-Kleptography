#Parameters come from . http://www.secg.org/sec2-v2.pdf
import hashlib
import hmac
from base64 import b64encode
from base64 import b64decode
from Crypto import Random
from Crypto.Cipher import AES
from Crypto.Util import Counter
import os



### EC Constants
#Domain
p256 = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF

#Curve parameters for the curve equation: y^2 = x^3 + a256*x +b256
a = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC
b = 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B

#Base point definition
Gx = 0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296
Gy = 0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5


#Curve order
n = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551

FF = GF(p256)

# Define a curve over that field with specified Weierstrass a and b parameters
E = EllipticCurve(FF, [a,b])
E.set_order(n)

G = E(FF(Gx), FF(Gy))

CTR = 0


def H(m) :
	#return int(hashlib.sha512(m).hexdigest(), 16)
	return hashlib.sha512(m).digest()

#####################################################################   ASA ECIES #####################################################################

def ecies_key_gen():
	kpriv = ZZ.random_element(0,n)
	kpub = G * kpriv
	return (kpriv, kpub)



def ecies_encrypt(K, m):
	r = ZZ.random_element(1,n)
	R = r * G
	#r*Kpub
	keys = H(str((r*K).xy()).encode('utf-8'))
	(kE, kM) = (keys[32:],keys[:32])
	cipher = AES.new(kE, AES.MODE_CTR)
	global NONCE 
	NONCE = b64encode(cipher.nonce).decode('utf-8')
	print(f'NONCE {NONCE}')
	c = cipher.encrypt(m)
	h_mac = hmac.new(kM, c, hashlib.sha256)
	tag = h_mac.digest() 
	return (R, c, tag)

	

def ecies_decrypt(k, c):
	(R, ciphertext, tag) = c
	keys = H(str((k * R).xy()).encode('utf-8'))
	(kE, kM) = (keys[32:], keys[:32])
	h_mac = hmac.new(kM, ciphertext, hashlib.sha256)
	new_tag = h_mac.digest()
	if tag != new_tag:
		print("Error: tags are different!")
		raise
	n = b64decode(NONCE)
	aes = AES.new(kE, AES.MODE_CTR, nonce=n)
	return aes.decrypt(ciphertext)

	
print("Normal ECIES: ")
(ecies_k, ecies_K) = ecies_key_gen()
m = b"i <3 ecies"
print(f'Chosen message: {m}')
ciphertext = ecies_encrypt(ecies_K, m)
m_decrypted = ecies_decrypt(ecies_k, ciphertext)
print(f'Decrypted message: {m_decrypted}')


#####################################################################   ASA ECIES #####################################################################

def KEM_Rg():
	return ZZ.random_element(1,n)

def KEM_Kg(psk, tag):
	return H(str((psk * tag).xy()).encode('utf-8'))

def KEM_Cg(r):
	return r*G

def KEM_Kd(dk, C):
	return H(str((dk * C).xy()).encode('utf-8'))

def asa_key_gen():
	ssk = ZZ.random_element(0,n)
	psk = G * ssk
	return (psk, ssk)


def asa_enc(pk, psk, tag):
	t = None
	r = None
	#just for the first iteration
	if tag == 0:
		r = KEM_Rg()
	else:
		t = KEM_Kg(psk, tag)
		# Need to be a int since we need it to compute R=r*G
		r = int.from_bytes(H(t), byteorder='little')


	#As we dont generate ek for the moment, ek = pk
	Ki = KEM_Kg(pk, r)
	Ci = KEM_Cg(r)
	tag = r
	return (Ki, Ci, tag)


def asa_rec(pk, ssk, Ci, Ci_prev):
	t = KEM_Kd(ssk, Ci_prev)
	r = int.from_bytes(H(t), byteorder='little')
	Ki = KEM_Kg(pk, r)
	return Ki

#Use AES GCM SIV à la place de CTR
def asa_encrypt(keys, m):
	(kE, kM) = (keys[32:],keys[:32])
	cipher = AES.new(kE, AES.MODE_CTR) 
	n = b64encode(cipher.nonce).decode('utf-8')
	c = cipher.encrypt(m)
	#h_mac = hmac.new(kM, c, hashlib.sha256)
	#tag = h_mac.digest() 
	return (c, n)

def asa_decrypt(k, c, n):
	(R, ciphertext) = c
	keys = H(str((k * R).xy()).encode('utf-8'))
	(kE, kM) = (keys[32:], keys[:32])
	n = b64decode(n)
	aes = AES.new(kE, AES.MODE_CTR, nonce=n)
	return aes.decrypt(ciphertext)

def asa_decrypt_broken(keys, ciphertext, n):
	(kE, kM) = (keys[32:], keys[:32])
	n = b64decode(n)
	aes = AES.new(kE, AES.MODE_CTR, nonce=n)
	return aes.decrypt(ciphertext)

print("\n\nASA ECIES: ")

(psk, ssk) = asa_key_gen()

m1 = b"ecies is great"
print(f'Message1 = {m1}')
(Ki1, Ci1, tag) = asa_enc(ecies_K, psk, 0)
print(f'Ki1 = {Ki1}\nCi1 = {Ci1}\ntag = {tag}')
(c1, n1) = asa_encrypt(Ki1, m1)
print(f'Ciphertext1 = {c1}')
m1_decrypted = asa_decrypt(ecies_k, (Ci1, c1), n1)
print(f'M1 decrypted = {m1_decrypted}')

m2 = b"ecies can be a ASA <3"
print(f'Message2 = {m2}')
(Ki2, Ci2, tag) = asa_enc(ecies_K, psk, tag)
print(f'Ki2 = {Ki2}\nCi2 = {Ci2}\ntag = {tag}')
(c2, n2) = asa_encrypt(Ki2, m2)

Ki2_comp = asa_rec(ecies_K, ssk, Ci2, Ci1)
print(f'Ki2 subversively obtained: {Ki2_comp}. Equals previous Ki? {Ki2 == Ki2_comp}')
#As we have (kE||kM), we don't need kpriv here and can decrypt the message!
m2_broken = asa_decrypt_broken(Ki2_comp, c2, n2)
print(f'We can obtain all next messages. For example we find Message2: {m2_broken}')
