# Change to DSA signatures with parameter Q 

def encode_message(m):
    return int("".join(list(map(lambda c: str(ord(c)), list(m)))))

def elgamal_parameters_gen(size):
    p = random_prime(2^(size), lbound = 2^(size-1))
    k = GF(p)
    g = k.multiplicative_generator()
    return (p, g)
    

def elgamal_key_gen(g, p):
    x = ZZ.random_element(1, p-2)
    y = power_mod(g, x, p)
    return (x, y)

def keyGen():
    q = random_prime(2^256)
    p = 1
    while(not is_prime(p)):
        r = ZZ.random_element(2^1100)
        p = q*r+1
    Fq = Integers(q)
    g = 1
    while(g == 1):
        g = Integers(p).random_element()^((p-1) //q)
    priv = Fq.random_element()
    pub = g^priv
    return (priv.lift(), pub,g,p,q)


# change 
def gen_first_signature(g, m, p, x):
    
    k = 0
    while gcd(k, p-1) != 1: 
        k = ZZ.random_element(1, p-2)

    r = power_mod(g, k, p)
    s = inverse_mod(k, p-1) * (m - x * r)
    return (m, r, s, k)

def gen_second_signature(g, k, m, p, x, Y):
    c = power_mod(Y, k, p)
    k_prime = inverse_mod(int(c), p-1)
    k_next = 0

    if gcd(c, p-1) == 1 and gcd(power_mod(g, k_prime, p), p-1) == 1:
        k_next = inverse_mod(int(c), p-1)
    else:
        print("Attack failed")
        while True:
            k_next = ZZ.random_element(1, p-2)
            if gcd(k_next, p-1) == 1:
                break

    r_next = power_mod(g, k_next, p)
    s_next = inverse_mod(int(k_next), p) * (m - x * r_next)
    return (m, r_next, s_next)


def key_recovery(r, s, p, X):
    (m_next, r_next, s_next) = s
    print(f'Key recovery: {m_next}  {r_next}  {s_next}')
    if gcd(r_next, p-1) != 1:
        print("Error: SETUP has not been used!")
        raise
    else:
        c = power_mod(r, X, p)
        tmp = m_next - s_next/c
        print(f'type r_next: {type(r_next)} type p : {type(p)}')
        inv = inverse_mod(int(r_next), p-1)
        x = inverse_mod(int(r_next), p-1) * (m_next - s_next/c)
    return x

(P, G) = elgamal_parameters_gen(32)
print(f'P = {P} G = {G}')

(X, Y) = elgamal_key_gen(G, P)
print(f'X = {X} Y = {Y}')


(x, y) = elgamal_key_gen(G, P)
print(f'x = {x} y = {y}')

m1 = "HI"
encoded_message = encode_message(m1)

(_m, r, s, k) = gen_first_signature(G, encoded_message, P, x)
print(f'm = {_m} r = {r} s = {s}')


m2 = "BYE"
encoded_message = encode_message(m2)
(_m, r_next, s_next) = gen_second_signature(G, k, encoded_message, P, x, Y)
print(f'm = {_m} r_next = {r_next} s_next = {s_next}')

k_priv = key_recovery(r, (_m, r_next, s_next), P, X)
print(f'private key obtained: {k_priv}')