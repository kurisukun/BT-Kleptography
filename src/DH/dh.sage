""" SETUP in Diffie-Hellman

This scrpts shows an example of a SETUP attack on Diffie-Hellman key exchange 
and more precisely in its key generation.

Functions and notation based on Yung and Young article: 
Using cryptography against cryptography


This script needs this modules to be installed to work :
    - hashlib 
    - base64 

Author: Chris Barros Henriques
Date: 30-07-21
"""

import hashlib
from base64 import b64encode

def H(str, n):
    """Hashing function whose value is between 0 and n-1

    Parameters
    ----------
    str : str
        The string to be encoded
    n : int
        The modulus

    Returns
    -------
    int
        An integer between 0 and n-1 
    """

    str = str.encode('utf-8')
    hash = hashlib.sha512(str).digest()
    value = int.from_bytes(hash, byteorder='little')
    return int(value)%(n-1)


def dh_parameters_gen(size):
    """Diffie-Hellman parameters generation 

    Parameters
    ----------
    size : str
        The size of the randomly generated prime p

    Returns
    -------
    tuple
        A tuple containing the prime p and a generator g of group Zp* 
    """

    p = random_prime(2^(size), lbound = 2^(size-1))
    Fp = Integers(p)
    g = Fp.unit_gens()
    return (p, g[0])

def gen_first_keypair(p, g):
    """ Generation of first Diffie-Hellman keypair 

    Parameters
    ----------
    p : int
        The prime corresponding to the cardinality of Zp* set 
    g : int
        A generator of Zp*

    Returns
    -------
    tuple
        A tuple containing the private and public key for the
        key exchange  
    """

    x1 = ZZ.random_element(1, p-1)
    y1 = power_mod(g, x1, p)
    return (x1, y1)


def gen_second_keypair(p, g, Y, W, a, b, x1):
    """ Generation of second Diffie-Hellman keypair.
    The key pairs generated are subverted by using attacker's1
    public key and fixed integers W, a, b.

    The fixed parameters permit to protect the SETUP attack 
    against an user trying to guess if its key pair is 
    subverted

    Parameters
    ----------
    p : int
        The prime corresponding to the cardinality of Zp* set 
    g : int
        A generator of Zp*
    Y : int
        The attacker's public key
    W : int
        Fixed integer 
    a : int
        Fixed integer 
    b : int
        Fixed integer 

    Returns
    -------
    tuple
        A tuple containing the private and public key for the
        key exchange  
    """

    p = int(p)
    g = int(g)
    Y = int(Y)
    W = int(W)
    a = int(a)    
    b = int(b)
    x1 = int(x1)    

    t = ZZ.random_element(0, 1)
    z = (power_mod(g, x1 - W*t ,p) * power_mod(Y, -a*x1 - b, p)) % p
    x2 = H(str(z), p-1)
    y2 = power_mod(g, x2, p)
    return x2, y2

def gen_shared_secret(x, y, p):
    """ Computes the Diffie-Hellman shared secret

    Parameters
    ----------
    x : int
        Your private key
    y : int
        Other party public key
    p : int
        The prime corresponding to the cardinality of Zp* set 

    Returns
    -------
    int
        The shared secret 
    """

    return power_mod(y, x, p)

def key_recovery(p, g, y1, y2, a, b, W, X):
    """ Recovers user's private key based on the fact we have access to 
    two generated public key. One with function gen_first_keypair and 
    the other with gen_second_keypair. 

    Parameters
    ----------
    p : int
        The prime corresponding to the cardinality of Zp* set 
    g : int
        A generator of Zp*
    y1: int
        The first public key obtained with gen_first_keypair
    y2: int
        The second public key obtained with gen_second_keypair
    a : int
        Fixed integer
    b : int
        Fixed integer
    W : int
        Fixed integer

    Returns
    -------
    int
        The private key of the victim
    """

    p = int(p)
    g = int(g)
    y1 = int(y1)
    y2 = int(y2)
    W = int(W)
    a = int(a)    
    b = int(b)
    X = int(X)    

    r = (power_mod(y1, a, p) * power_mod(g, b, p)) % p
    print(f'    r ≡ y1_a^a ·g^b = {r} (mod {p})')

    z1 = (y1 * inverse_mod( power_mod(r, X, p), p)) %p
    print(f'    z ≡ y1_a^a ·g^b = {r} (mod {p})')

    tmp = power_mod(g, H(str(z1), p-1), p)
    if y2 == tmp:
        return H(str(z1), p-1)
    else:
        z2 = z1 * inverse_mod(power_mod(g, W, p), p)
        tmp = power_mod(g, H(str(z2), p-1), p)
        if y2 == tmp:
            return H(str(z2), p-1)
        else:
            raise ValueError('SETUP attack has not been used here')


def main():

    #Fixed integers. This integers give a good probability 
    #for the attack to work 
    a, b, W = (1, 4, 2437)


    print(f'######## Generation of parameters ########')
    (p, g) = dh_parameters_gen(32)
    print(f'    p = {g}')
    print(f'    g = {g}\n')

    print(f'######## ATTACKER  ########')
    print(f'Eve generates her keys using g = {g} and p = {p} as parameters')
    X, Y = gen_first_keypair(p, g)
    print(f'    X = {X}')
    print(f'    Y ≡ g^X = {g}^{X} ≡ {Y} (mod {p})\n')

    print(f'######## VICTIM  ########')
    print(f'- First signature: Alice want to communicate with Bob -')
    print(f'Alice generates her keys using g = {g} and p = {p} as parameters')
    x1_a, y1_a = gen_first_keypair(p, g)
    print(f'    x1_a = {x1_a} (What we are looking for)')
    print(f'    y1_a ≡ g^x1_a = {g}^{x1_a} ≡ {y1_a} (mod {p})\n')
    print(f'Alice sends her public key to Bob')

    print(f'Bob generates her keys using g = {g} and p = {p} as parameters')
    x1_b, y1_b = gen_first_keypair(p, g)
    print(f'    x1_b = {x1_b}')
    print(f'    y1_b ≡ g^x1_b = {g}^{x1_b} ≡ {y1_b} (mod {p})\n')
    print(f'Bob sends his public key to Alice')

    print(f'Alice and Bob can now both compute the shared secret')
    print(f'    Alice by computing: s1 ≡ y1_b^x1_a = {gen_shared_secret(x1_a, y1_b, p)}')
    print(f'    Bob by computing: s1 ≡ y1_a^x1_b = {gen_shared_secret(x1_b, y1_a, p)}\n')


    print(f'- Second signature: Alice want to communicate with Carol -')
    print(f'Alice generates her keys using g = {g} and p = {p} as parameters')
    x2_a, y2_a = gen_second_keypair(p, g, Y, W, a, b, x1_a)
    print(f'    x2_a = {x2_a} (THIS IS WHAT WE WANT)')
    print(f'    y2_a ≡ g^x2_a = {g}^{x2_a} ≡ {y2_a} (mod {p})\n')
    print(f'Alice sends her public key to Carol')

    print(f'Carol generates her keys using g = {g} and p = {p} as parameters')
    x1_c, y1_c = gen_first_keypair(p, g)
    print(f'    x1_c = {x1_c}')
    print(f'    y1_c ≡ g^x1_c = {g}^{x1_c} ≡ {y1_c} (mod {p})\n')
    print(f'Carol sends her public key to Alice')

    print(f'Alice and Carol can now both compute the shared secret')
    print(f'    Alice by computing: s2 ≡ y1_c^x2_a = {gen_shared_secret(x2_a, y1_c, p)}')
    print(f'    Carol by computing: s2 ≡ y2_a^x1_c = {gen_shared_secret(x1_c, y2_a, p)}')

    print(f'######## SETUP ATTACK ########')

    key = key_recovery(p, g, y1_a, y2_a, a, b, W, X)
    print(f'    Eve has obtained Alice\'s private key: {key == x2_a}')
    print(f'    She can now use Carole\'s public key to compute the shared secret: s2 ≡ y1_c^x2_a = {gen_shared_secret(x2_a, y1_c, p)}')

if __name__ == "__main__":
    main()