""" ASA in ECIES

This scrpts shows an example of an ASA attack on ECIES.

Functions and notation based on Chen, Huang and Yung's article: 
Subvert KEM to Break DEM: Practical Algorithm-Substitution 
Attacks on Public-Key Encryption


This script needs this modules to be installed to work :
	- Crypto
    - hashlib 
    - base64 
	- os

Author: Chris Barros Henriques
Date: 30-07-21
"""

import hashlib
import hmac
from base64 import b64encode
from base64 import b64decode
from Crypto import Random
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
import os


#Parameters come from http://www.secg.org/sec2-v2.pdf
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


def H(m):
	"""Hashing function 

	Parameters
	----------
	m : str
		The string to be hashed

	Returns
	-------
	bytes
		Hashed value in the form of a set of bytes  
	"""
	return hashlib.sha512(m).digest()

def ecies_key_gen():
	"""ECIES normal KEM function for key generation

	Returns
	-------
	tuple
		A tuple containing the private key and the public key
	"""
	kpriv = ZZ.random_element(0,n)
	kpub = G * kpriv
	return (kpriv, kpub)

def KEM_Rg():
	"""ECIES normal KEM function for the generation of r 
	the random integer in {1, 2, ..., n}

	Returns
	-------
	int
		The random integer r
	"""
	return ZZ.random_element(1,n)

def KEM_Kg(psk, r):
	"""ECIES normal KEM function for session key K generation for
	the encapsulation phase

	Parameters
	----------
	psk : EllipticCurvePoint_finite_field
		Public key of the attacker (normally hardwired)
	r :	int
		The previously randomly generated value r

	Returns
	-------
	bytes
		Session key K in the form of a set of bytes
	"""
	return H(str((psk * r).xy()).encode('utf-8'))

def KEM_Cg(r):
	"""ECIES normal KEM function for generating the value C which permits 
	the receiver to recompute the shared secret

	Parameters
	----------
	r : str
		The string to be hashed

	Returns
	-------
	EllipticCurvePoint_finite_field
		The value C to be shared with the other user in order to recompute
		the shared secret
	"""
	return r*G


def KEM_Kd(dk, C):
	"""ECIES normal KEM function for session key K generation for
	the decapsulation phase 

	Parameters
	----------
	dk : int
		Decapsulation key
	C :	EllipticCurvePoint_finite_field
		Value used to compute the shared secret
	
	Returns
	-------
	bytes
		Session key K in the form of a set of bytes
	"""
	return H(str((dk * C).xy()).encode('utf-8'))

def ASA_Gen():
	"""ASA KEM function for key generation

	Returns
	-------
	tuple
		A tuple containing the public key and the private key
		for the attacker
	"""
	ssk = ZZ.random_element(0,n)
	psk = G * ssk
	return (psk, ssk)


def ASA_Enc(pk, psk, tau):
	"""Generates the session key K and the ciphertext of the KEM
	part of the ASA

	Parameters
	----------
	pk : int
		Public key of the victim
	psk :	int
		Public key of the attacker (normally hardwired but passed
		as argument for convenience)
	tau : 	int
		Signature key of the generated ciphertext

	Returns
	-------
	tuple
		A tuple containing the session key, the ciphertext 
		for the futur computation of the shared secret, and 
		the tag key
	"""

	t = None
	r = None
	#just for the first iteration
	if tau == 0:
		r = KEM_Rg()
		print(f'	r is drawn randomly: {r}')
	else:
		t = KEM_Kg(psk, tau)
		print(f'	t is computed as dk·tau: {t}')
		# Need to be a int since we need it to compute R=r*G
		r = int.from_bytes(H(t), byteorder='little')
		print(f'	r is derived from the hash of t: {r}')


	#As we dont generate ek for the moment, ek = pk
	Ki = KEM_Kg(pk, r)
	print(f'	Generation of new session key K: {Ki}')
	Ci = KEM_Cg(r)
	print(f'	Generation of C for computing the shared secret: {Ci}\n')
	tau = r
	return (Ki, Ci, tau)


def ASA_Rec(pk, ssk, Ci, Ci_prev):
	"""Recovers the private key of the victim using his public key,
	two previous ciphertexts generated with the same instance of 
	ASA_Enc and the private key of the attacker

	Parameters
	----------
	pk : int
		Public key of the victim
	ssk : int
		Private key of the attacker
	Ci : int
		i-th generated ciphertext
	Ci_prev : int
		(i-1)-th generated ciphertext 


	Returns
	-------
	bytes
		The session key K in the form of bytes
	"""
	t = KEM_Kd(ssk, Ci_prev)
	r = int.from_bytes(H(t), byteorder='little')
	Ki = KEM_Kg(pk, r)
	return Ki

#Use AES GCM SIV à la place de CTR
def DEM_Encrypt(keys, m):
	"""DEM encryption. Use AES mode SIV to encrypt
	the message m with the use of tuple keys which
	contains encapsulation key and MAC key

	Parameters
	----------
	keys : bytes
		Public key of the victim
	m :	bytes
		The message to be encrypted

	Returns
	-------
	tuple
		A tuple containing the ciphertext, the tag and
		the nonce for AES
	"""
	(kE, kM) = (keys[32:],keys[:32])
	nonce = get_random_bytes(16)
	cipher = AES.new(kE, AES.MODE_SIV, nonce=nonce) 
	n = b64encode(cipher.nonce).decode('utf-8')
	c, tag = cipher.encrypt_and_digest(m)
	#h_mac = hmac.new(kM, c, hashlib.sha256)
	#tag = h_mac.digest() 
	return (c, tag, n)

def asa_decrypt(sk, c, tag, n):
	"""DEM decryption. Use AES mode SIV to decrypt
	the ciphertext c (R and ciphertext) with the use
	of the shared secret. 

	Parameters
	----------
	k : int
		Secret key of the user
	c :	tuple
		Tuple containing the R value to compute the shared
		secret, and the ciphertext
	tag : bytes
		Signature key of the generated ciphertext
	n : bytes
		Nonce used for the encryption of the original 
		message 

	Returns
	-------
	bytes
		The message decrypted
	"""
	(R, ciphertext) = c
	keys = H(str((sk * R).xy()).encode('utf-8'))
	(kE, kM) = (keys[32:], keys[:32])
	n = b64decode(n)
	aes = AES.new(kE, AES.MODE_SIV, nonce=n)
	return aes.decrypt_and_verify(ciphertext, tag)

def asa_decrypt_broken(keys, ciphertext, tag, n):
	"""DEM decyption without the need of the private key
	of the victim but directly with keys which contains
	(encapsulation key and MAC key)

	Parameters
	----------
	keys : bytes
		Secret key of the user
	ciphertex :	bytes
		Tuple containing the R value to compute the shared
		secret, and the ciphertext
	tag : bytes
		Signature key of the generated ciphertext
	n : bytes
		Nonce used for the encryption of the original 
		message 

	Returns
	-------
	bytes
		The message decrypted with no use of the private key
	"""
	(kE, kM) = (keys[32:], keys[:32])
	n = b64decode(n)
	aes = AES.new(kE, AES.MODE_SIV, nonce=n)
	return aes.decrypt_and_verify(ciphertext, tag)


print(f'######## ECIES Parameters ########')
print(f'	Domain p256 = {p256}')
print(f'	Curve parameter a = {a}')
print(f'	Curve parameter b = {b}')
print(f'	Base point G = (Gx, Gy) = ({Gx}, {Gy})')
print(f'	Curve order n = {b}\n\n')

print(f'######## ATTACKER ########')
(psk, ssk) = ASA_Gen()
print(f'Eve generates her keys')
print(f'	ssk = {ssk}')
print(f'	psk = ssk · G = {psk}\n\n')

print(f'######## VICTIM ########')
(sk_a, pk_a) = ecies_key_gen()
print(f'Alice generates her keys')
print(f'	sk_a = {sk_a}')
print(f'	pk_a = sk_a · G = {pk_a}\n')

(sk_b, pk_b) = ecies_key_gen()
print(f'Bob generates his keys')
print(f'	sk_b = {sk_b}')
print(f'	pk_b = sk_b · G = {pk_b}\n\n')


m1 = b"Hi Bob!"
print(f'Alice wants to send the message to Bob: {m1}')
(Ki1, Ci1, tag) = ASA_Enc(pk_b, psk, 0)
print(f'Encryption of {m1} using K1:')
(c1, tag1, n1) = DEM_Encrypt(Ki1, m1)
print(f'	c1 = {c1}\n')
print(f'Bob receives the message and decrypts it: ')
m1_decrypted = asa_decrypt(sk_b, (Ci1, c1), tag1, n1)
print(f'	m1 = {m1_decrypted}')

m2 = b"How are you? Long time no see!"
print(f'Alice wants to send this other message to Bob: {m2}')
(Ki2, Ci2, tag) = ASA_Enc(pk_b, psk, tag)
print(f'Encryption of {m2} using K2:')
(c2, tag2, n2) = DEM_Encrypt(Ki2, m2)
print(f'	c2 = {c2}\n')
print(f'Bob receives the new message and decrypts it: ')
m2_decrypted = asa_decrypt(sk_b, (Ci2, c2), tag2, n2)
print(f'	m2 = {m2_decrypted}\n\n')


print(f'######## ASA ATTACK ########')
print(f'Eve attacks the session key K2')
Ki2_comp = ASA_Rec(pk_b, ssk, Ci2, Ci1)
print(f'Ki2 subversively obtained: {Ki2_comp}')
#As we have (kE||kM), we don't need kpriv here and can decrypt the message!
m2_broken = asa_decrypt_broken(Ki2_comp, c2, tag2, n2)
print(f'Eve can obtain all next messages. For example m2: {m2_broken}')
