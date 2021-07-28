""" SETUP in El Gamal signature

This scrpts shows an example of a SETUP attack on El Gamal signatures.

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
        The encoded message represented as an integer. Each character of m 
        is converted into his ASCII value 
    """

    return int("".join(list(map(lambda c: str(ord(c)), list(m)))))

def elgamal_parameters_gen(size):
    """ El Gamal parameters generation

    Parameters
    ----------
    size :  int
        The number of bits for the size of the randomly
        generated prime p
        
    Returns
    -------
    tuple
        A tuple containing the prime p and a generator g of group Zp*   
    """

    p = random_prime(2^(size), lbound = 2^(size-1))
    Fp = Integers(p)
    g = Fp.unit_gens()
    return (p, g[0])

def elgamal_key_gen(g, p):
    """ El Gamal keys generation

    Parameters
    ----------
    g : int
        A generator of Zp*
    p : int
        The prime corresponding to the cardinality of Zp* set 
        
    Returns
    -------
    tuple
        A tuple containing the private and public key   
    """

    x = ZZ.random_element(1, p-2)
    y = power_mod(g, x, p)
    return (x, y)


def gen_first_signature(g, m, p, x):
    """ Generation of the first signature

    Parameters
    ----------
    g : int
        A generator of Zp*
    m : int
        The message to send is and encoded as an integer
    p : int
        The prime corresponding to the cardinality of Zp* set
    x : int
        The private key
        
    Returns
    -------
    tuple
        A tuple containing:
            - m the initial message
            - r the first part of the signature
            - s the second part of the signature
            - k the randomly generated integer (returned for 
            practicality and clarity of the code)
    """

    p = int(p)
    g = int(g)
    x = int(x)
    k = 0
    while gcd(k, p-1) != 1: 
        k = ZZ.random_element(1, p-2)
    
    print(f'    Generation of k1 = {k} such that gcd(k1, p-1) = 1')

    r = power_mod(g, k, p)
    print(f'    r1 ≡ g^k1 = {g}^{k} ≡ {r} (mod {p})')
    s = (inverse_mod(k, p-1) * (m - x * r)) % (p-1)
    print(f'    s1 ≡ k1^−1(m1 − x · r1 ) ≡ {inverse_mod(k, p-1)}({m} - {x}·{r}) ≡ {s} (mod {p-1})')
    return (m, r, s, k)

def gen_second_signature(g, k, m, p, x, Y):
    """ Generation of the second signature

    Parameters
    ----------
    g : int
        A generator of Zp*
    k : int
        Random integer generated in previous signature
    m : int
        The message to send is and encoded as an integer
    p : int
        The prime corresponding to the cardinality of Zp* set
    x : int
        The private key
    Y : int
        The attacker's public key
        
    Returns
    -------
    tuple
        A tuple containing:
            - m the initial message
            - r the first part of the signature
            - s the second part of the signature
    """

    g = int(g)
    k = int(k)
    m = int(m)
    p = int(p)
    Y = int(Y)

    c = power_mod(Y, k, p)
    print(f'c ≡ Y^k1 ≡ {Y}^{k} ≡ {c} (mod {p})')

    k_next = 0
    if gcd(c, p-1) == 1 and gcd(power_mod(g, inverse_mod(int(c), p-1), p), p-1) == 1:
        k_next = inverse_mod(int(c), p-1)
    else:
        print("Attack failed")
        raise ValueError('SETUP attack has not been used here')
        while True:
            k_next = ZZ.random_element(1, p-2)
            if gcd(k_next, p-1) == 1:
                break

    print(f'    k2 ≡ c^-1 ≡ {k_next} (mod {p-1})')

    r_next = power_mod(g, k_next, p)
    print(f'    r2 ≡ g^k2 = {g}^{k_next} ≡ {r_next} (mod {p})')
    s_next = (inverse_mod(int(k_next), p-1) * (m - x * r_next)) % (p-1)
    print(f'    s2 ≡ k2^−1(m2 − x · r2 ) ≡ {inverse_mod(k_next, p-1)}({m} - {x}·{r_next}) ≡ {s_next} (mod {p-1})\n')
    return (m, r_next, s_next)

def verify_signature(p, g, y, m, r, s):
    """ El Gamal signature verification

    Parameters
    ----------
    p : int
        The prime corresponding to the cardinality of Zp* set 
    g : int
        A generator of Zp*
    y : int
        Public key of the user whose private key was 
        used to generate r and s
    m : int
        Message that has been signed
    r : int
        The first part of the signature
    s : int
        The second part of the signature
        
    Returns
    -------
    bool
        True if the signature (r,s) corresponds to the 
        message m given in parameter   
    """

    sig = power_mod(g, m, p)
    print(f'    g^m ≡ {sig} (mod {p})')
    sig_prime = (power_mod(y, r, p) * power_mod(r, s, p)) % p
    print(f'    y^r · r^s ≡ {sig_prime} (mod {p})')
    
    return (sig == sig_prime)
    


def key_recovery(r, s, p, X):
    """ Recover a user's private key based on the fact that the 
    second signature has been subverted 

    Parameters
    ----------
    r : int
        The first part of the second signature
    s : int
        The second part of the second signature
    p : int
        The prime corresponding to the cardinality of Zp* set 
    X : int
        The private key of the attacker

    Returns
    -------
    int
        The private key of the victim  
    """

    (m_next, r_next, s_next) = s
    print(f'Key recovery: {m_next}  {r_next}  {s_next}')
    if gcd(r_next, p-1) != 1:
        print("Error: SETUP has not been used!")
        raise
    else:
        c = power_mod(r, X, p)
        print(f'    She computes c ≡ ri^X (mod {p}) ≡ {r}^{X} (mod {p} ≡ {c} (mod {p}))')
        x = (inverse_mod(int(r_next), p-1) * (m_next - s_next*inverse_mod(c, p-1))) % (p-1)
        print(f'    x = r2^-1 (m2 - s2//c) = {r_next}^-1 ({m_next} - {s_next}//{c})')
    return x



def main():
    print(f'######## Generation of parameters ########')
    (p, g) = elgamal_parameters_gen(32)
    print(f'    p = {g}')
    print(f'    g = {g}\n')
    print(f'######## ATTACKER  ########')
    print(f'Eve generates her keys using g = {g} and p = {p} as parameters')
    (X, Y) = elgamal_key_gen(g, p)
    print(f'    X = {X}')
    print(f'    Y ≡ g^X = {g}^{X} ≡ {Y} (mod {p})\n')

    print(f'######## VICTIM  ########')
    print(f'Alice generates her keys using g = {g} and p = {p} as parameters')
    (x, y) = elgamal_key_gen(g, p)
    print(f'    x = {x} (This is what we are looking for)')
    print(f'    y ≡ g^x = {g}^{x} ≡ {y} (mod {p})\n')


    m1 = "HI"
    print(f'Alice wants to send the message: {m1}')
    encoded_message = encode_message(m1)
    print(f'encoded message: {encoded_message}\n')
    print(f'Alice generates the first signature:')
    (_m, r, s, k) = gen_first_signature(g, encoded_message, p, x)

    print(f'Bob verifies the signature with ({_m}, {r}, {s})')

    print(f'The signature corresponds: {verify_signature(p, g, y, _m, r, s)}')

    m2 = "OK"
    print(f'Alice now wants to send the message: {m2}')
    encoded_message = 1511
    encoded_message = encode_message(m2)
    print(f'encoded message: {encoded_message}\n')
    print(f'Alice generates the second signature:')
    (_m, r_next, s_next) = gen_second_signature(g, k, encoded_message, p, x, Y)

    print(f'Bob verifies the signature with ({_m}, {r}, {s})')

    print(f'The signature corresponds: {verify_signature(p, g, y, _m, r_next, s_next)}')

    print(f'######## SETUP ATTACK ########')
    print(f'Eve attacks Alice private key: ')
    k_priv = key_recovery(r, (_m, r_next, s_next), p, X)
    print(f'    Alice private key obtained: {k_priv}')


if __name__ == "__main__":
    main()