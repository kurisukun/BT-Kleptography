# Change to DSA signatures with parameter Q 

def encode_message(m):
    return int("".join(list(map(lambda c: str(ord(c)), list(m)))))

def elgamal_parameters_gen(size):
    p = random_prime(2^(size), lbound = 2^(size-1))
    Fp = Integers(p)
    g = Fp.unit_gens()
    return (p, g[0])
    

def elgamal_key_gen(g, p):
    x = ZZ.random_element(1, p-2)
    y = power_mod(g, x, p)
    return (x, y)

# change 
def gen_first_signature(g, m, p, x):

    p = int(p)
    g = int(g)
    x = int(x)
    k = 0
    while gcd(k, p-1) != 1: 
        k = ZZ.random_element(1, p-2)
    
    print(f'    Generation of k1 = {k} such that gcd(k1, P-1) = 1')

    r = power_mod(g, k, p)
    print(f'    r1 ≡ G^k1 = {g}^{k} ≡ {r} (mod {p})')
    s = (inverse_mod(k, p-1) * (m - x * r)) % (p-1)
    print(f'    s1 ≡ k1^−1(m1 − x · r1 ) ≡ {inverse_mod(k, p-1)}({m} - {x}·{r}) ≡ {s} (mod {p-1})')
    return (m, r, s, k)

def gen_second_signature(g, k, m, p, x, Y):
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
    print(f'    r2 ≡ G^k2 = {g}^{k_next} ≡ {r_next} (mod {p})')
    s_next = (inverse_mod(int(k_next), p-1) * (m - x * r_next)) % (p-1)
    print(f'    s2 ≡ k2^−1(m2 − x · r2 ) ≡ {inverse_mod(k_next, p-1)}({m} - {x}·{r_next}) ≡ {s_next} (mod {p-1})\n')
    return (m, r_next, s_next)


def key_recovery(r, s, p, X):
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


print(f'######## Generation of parameters ########')
(P, G) = elgamal_parameters_gen(32)
print(f'    P = {P}')
print(f'    G = {G}\n')
print(f'######## ATTACKER  ########')
print(f'Eve generates her keys using G={G} and P={P} as parameters')
(X, Y) = elgamal_key_gen(G, P)
print(f'    X = {X}')
print(f'    Y ≡ g^X = {G}^{X} ≡ {Y} (mod {P})\n')

print(f'######## VICTIM  ########')
print(f'Alice generates her keys using G={G} and P={P} as parameters')
(x, y) = elgamal_key_gen(G, P)
print(f'    x = {x} (THIS IS WHAT WE WANT)')
print(f'    y ≡ g^x = {G}^{x} ≡ {y} (mod {P})\n')


m1 = "HI"
print(f'Alice wants to send the message: {m1}')
encoded_message = encode_message(m1)
print(f'encoded message: {encoded_message}\n')
print(f'Alice generates the first signature:')
(_m, r, s, k) = gen_first_signature(G, encoded_message, P, x)
print(f'm = {_m} r = {r} s = {s}')

m2 = "OK"
print(f'Alice now wants to send the message: {m2}')
encoded_message = 1511
encoded_message = encode_message(m2)
print(f'encoded message: {encoded_message}\n')
print(f'Alice generates the second signature:')
(_m, r_next, s_next) = gen_second_signature(G, k, encoded_message, P, x, Y)

print(f'######## SETUP ATTACK ########')
print(f'Eve attacks Alice private key: ')
k_priv = key_recovery(r, (_m, r_next, s_next), P, X)
print(f'    Alice private key obtained: {k_priv}')