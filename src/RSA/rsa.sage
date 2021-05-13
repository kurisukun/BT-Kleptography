def encode_message(m):
    return int("".join(list(map(lambda c: str(ord(c)), list(m)))))

def rsa_encrypt(m, e, n) :
    return power_mod (m, e, n)

def rsa_decrypt(c, d, n) :
    return power_mod(c, d, n)

def setup_attacker_key_gen(size):
    E = 65535
    phi = 0
    P = 0
    Q = 0
    N = 0
    while gcd(E, phi) != 1:
        P = random_prime (2^(size / 2), lbound = 2^(size/2-1))
        Q = random_prime (2^(size / 2), lbound = 2^(size/2-1))
        N = P*Q
        phi = (P-1)*(Q-1)
    D = inverse_mod(E, phi)
    print("\n\n ######## ATTACKER ########")
    print(f'P = {P} and Q = {Q}')
    print(f'N = PQ = {P} · {Q} = {N}')
    print(f'ϕ(N) = (P − 1)(Q − 1) = {P-1}*{Q-1} = {phi}')
    print(f'E = {E}')
    print(f'D ≡ E^−1 ≡ {D} (mod N)')
    return (E, D, N)

def setup_victim_key_gen(size, E, N):
    q = random_prime ( 2^(size / 2), lbound = 2^(size/2-1))
    
    e = 0
    phi = 0
    while gcd(e, phi) != 1:
        p = random_prime ( 2^(size / 2), lbound = 2^(size/2-1))
        n = p*q
        phi = (p-1)*(q-1)
        e = power_mod(p, E, N)
    d = inverse_mod(e, phi)

    print("\n\n ######## VICTIM ########")
    print(f'p = {p} and q = {q}')
    print(f'n = pq = p · q = {n}')
    print(f'ϕ(n) = (p − 1)(q − 1) = {p-1}*{q-1} = {phi}')
    print(f'e ≡ p^E ≡ {p}^{E} ≡ {e} (mod N)')
    print(f'd ≡ e^−1 ≡ {d} (mod n)')
    return (e,d,n)


def rsa_setup_attack(c, D, N, e, n):
    p = power_mod(e, D, N)
    print("\n\n ######## SETUP ########")
    print(f'p ≡ e^D = {e}^{D} mod(N) ≡ {p} ≡ {p} (mod {N})')
    q = n/p
    phi = (p-1)*(q-1)
    d = inverse_mod(e, phi)
    return rsa_decrypt(c, d, n)


eve_keys = setup_attacker_key_gen(64)
(eve_e, eve_d, eve_n) = eve_keys

alice_keys = setup_victim_key_gen(64, eve_e, eve_n)
(alice_e, alice_d, alice_n) = alice_keys


message = "TEST"
encoded_message = encode_message(message)
print(f'Message to send: {encoded_message}')

c = rsa_encrypt(encoded_message, alice_e, alice_n)
print(f'Ciphertext: {c}')

pwned = rsa_setup_attack(c, eve_d, eve_n, alice_e, alice_n)
print(f'Pwned message: {pwned}')