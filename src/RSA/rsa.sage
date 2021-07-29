""" SETUP in RSA

This scrpts shows an example of a SETUP attack on RSA encryption scheme 
and more precisely in its key generation.

Functions and notation based on Yung and Young article: 
The Dark Side of "Black-Box" Cryptography or: Should We Trust Capstone?


No requirements needed to use this script

Author: Chris Barros Henriques
Date: 30-07-21
"""

def encode_message(m):
    """Encode the string m into a interger

    Parameters
    ----------
    m : str
        The string to be encoded

    Returns
    -------
    int
        The encoded message represented as an integer. Each character of m is converted into his ASCII value 
    """

    return int("".join(list(map(lambda c: str(ord(c)), list(m)))))

def rsa_encrypt(m, e, n) :
    """ RSA encryption 

    Parameters
    ----------
    m : str
        The message to be encrypted
    e:  int
        The public key of the user to whom we want to send the encrypted message
    n:  int
        The modulus shared between the two communicating users

    Returns
    -------
    int
        The encrypted message 
    """

    print(f'Encryption of {m}:')
    c = power_mod (m, e, n)
    print(f'    c = m^e mod(n) = {c}\n')
    return c

def rsa_decrypt(c, d, n) :
    """ RSA decryption
    
    Parameters
    ----------
    c : str
        The ciphertext to be decrypted
    d:  int
        The private key of the user who received a encrypted message
    n:  int
        The modulus shared between the two communicating users

    Returns
    -------
    int
        The decrypted message 
    """

    print(f'Decryption of {c}:')
    m = power_mod(c, d, n)
    print(f'    m = c^d mod(n) = {m}\n')
    return m

def setup_attacker_key_gen(size):
    """Computes the RSA keys for the attacker using normal RSA key generation

    Parameters
    ----------
    size : int
        The size of the generated keys which is computed as: 2^(size/2))

    Returns
    -------
    tuple
        A tuple of integers representing public key, private key and modulus 
    """

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
    """Computes the RSA keys for the attacker using a subverted version of RSA encryption scheme. 

    Parameters
    ----------
    size : int
        The size of the generated keys which is computed as: 2^(size/2))
    E : int
        The public key of the attacker hardwired into this function
    N : int
        The modulus of the attacker

    Returns
    -------
    tuple
        A tuple of integers representing subverted public key, private key and modulus 
    """

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
    print("Bob generates his keys using contaminated system:")
    print(f'    p = {p} and q = {q}')
    print(f'    n = p · q = {n}')
    print(f'    ϕ(n) = (p − 1)·(q − 1) = {phi}')
    print(f'    e ≡ p^E ≡ {p}^{E} ≡ {e} (mod N)')
    print(f'    d ≡ e^−1 ≡ {d} (mod n) \n')
    return (e,d,n)


def rsa_setup_attack(c, D, N, e, n):
    """Recover a user's private key based on the fact that his public key e has been subverted 
    using public key E and modulus N and decrypts the given ciphertext c

    Parameters
    ----------
    c : int
        A ciphertext produced with the following parameters
    D : int
        Private key of the attacker
    N : int
        Modulus of the attacker
    e : int
        Subverted public key of the victim
    n : int
        Modulus of the victim

    Returns
    -------
    int
        The decrypted ciphertext 
    """

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

def main():
    eve_keys = setup_attacker_key_gen(32)
    (eve_e, eve_d, eve_n) = eve_keys

    bob_keys = setup_victim_key_gen(32, eve_e, eve_n)
    (bob_e, bob_d, bob_n) = bob_keys

    message = "Hi!"
    print(f'Alice wants to send the message: {message}')
    encoded_message = encode_message(message)
    print(f'Encoded message: {encoded_message} \n')

    print("Alice encrypts the message to send it to Bob")
    c = rsa_encrypt(encoded_message, bob_e, bob_n)

    print("Bob receives Alice's message. He decrypts it")
    plaintext = rsa_decrypt(c, bob_d, bob_n)

    print("Eve attacks Bob's private key")
    stolen_message = rsa_setup_attack(c, eve_d, eve_n, bob_e, bob_n)
    print(f'Eve has decrypted Alice\'s message: {stolen_message}')


if __name__ == "__main__":
    main()