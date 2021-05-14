def encode_message(m):
    return int("".join(list(map(lambda c: str(ord(c)), list(m)))))

def rsa_encrypt(m, e, n) :
    print(f'Encryption of {m}:')
    c = power_mod (m, e, n)
    print(f'    c = m^e mod(n) = {c}\n')
    return c

def rsa_decrypt(c, d, n) :
    print(f'Decryption of {c}:')
    m = power_mod(c, d, n)
    print(f'    m = c^d mod(n) = {m}\n')
    return m

def setup_attacker_key_gen(size):
    P = 0
    Q = random_prime(2^(size / 2), lbound = 2^(size/2-1))
    phi = 0
    N = 0
    E = 0
    while True:
        P = random_prime(2^(size / 2), lbound = 2^(size / 2-1))
        E = ZZ.random_element(1, 2^(size/2-1))
        N = P*Q
        phi = (P-1)*(Q-1)
        if gcd(E, phi) == 1 and 1 < E and E < phi:
            break
    D = inverse_mod(E, phi)
    print("######## ATTACKER ########")
    print("Eve generates her keys:")
    print(f'    P = {P} and Q = {Q}')
    print(f'    N = P · Q = {N}')
    print(f'    ϕ(N) = (P − 1)·(Q − 1) = {phi}')
    print(f'    E = {E}')
    print(f'    D ≡ E^−1 ≡ {D} (mod N) \n')
    return (E, D, N)

def setup_victim_key_gen(size, E, N):
    p = 0
    q = random_prime ( 2^(size / 2), lbound = 2^(size/2-1))
    phi = 0
    n = 0
    e = 0
    while gcd(e, phi) != 1:
        p = random_prime ( 2^(size / 2), lbound = 2^(size/2-1))
        n = p*q
        phi = (p-1)*(q-1)
        e = power_mod(p, E, N)
    d = inverse_mod(e, phi)
    print("######## VICTIM ########")
    print("Alice generates her keys using contaminated system:")
    print(f'    p = {p} and q = {q}')
    print(f'    n = p · q = {n}')
    print(f'    ϕ(n) = (p − 1)·(q − 1) = {phi}')
    print(f'    e ≡ p^E ≡ {p}^{E} ≡ {e} (mod N)')
    print(f'    d ≡ e^−1 ≡ {d} (mod n) \n')
    return (e,d,n)


def rsa_setup_attack(c, D, N, e, n):
    p = power_mod(e, D, N)
    print("######## SETUP ATTACK ########")
    print(f'    p ≡ e^D mod(N) ≡ {p}')
    q = n/p
    print(f'Knowing p, we can factor n to compute q:')
    print(f'    q = n/p = {q}')
    phi = (p-1)*(q-1)
    print(f'    ϕ(n) = (p − 1)·(q − 1) = {phi}')
    d = inverse_mod(e, phi)
    print(f'    d ≡ e^−1 ≡ {d} (mod n) \n')
    return rsa_decrypt(c, d, n)


eve_keys = setup_attacker_key_gen(32)
(eve_e, eve_d, eve_n) = eve_keys

alice_keys = setup_victim_key_gen(32, eve_e, eve_n)
(alice_e, alice_d, alice_n) = alice_keys

message = "Hi!"
print(f'Bob wants to send the message: {message}')
encoded_message = encode_message(message)
print(f'Encoded message: {encoded_message} \n')

print("Bob encrypts the message to send it to Alice")
c = rsa_encrypt(encoded_message, alice_e, alice_n)

print("Alice receives Bob's message. She decrypts it")
plaintext = rsa_decrypt(c, alice_d, alice_n)

print("Eve attacks Alice's private key")
stolen_message = rsa_setup_attack(c, eve_d, eve_n, alice_e, alice_n)
print(f'Eve has decrypted Bob\'s message: {stolen_message}')