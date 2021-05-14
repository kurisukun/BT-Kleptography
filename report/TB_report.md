## Introduction

In our modern, ultra-connected world, we readily imagine that the world's great powers have eyes and ears everywhere, that 1984 is no longer as fictional as it was less than half a century ago, and that the shadow of Big Brother is becoming ever more prominent. A world where our communications, even though encrypted, could be thwarted and read by malicious people without us even realizing it. Techniques for doing this exist and a new field of study that looks into the subject was born in 1996: kleptography. This will be the subject of this thesis.



## Specifications



### Problematic

 **//TODO**



### Goals:

- Study and presentation of the general concepts of the kleptography. This means showing its evolution through time (what has changed since 2013), explaining the different concepts (ASAs, SETUP attacks, contaminating algorithms and implementations of protocols) and which are the ways we can protect ourselves from it very comprehensively
- Implement kleptographic attacks
- Use the attacks in a threat scenario in a way an informed and uninformed public can understand kleptography and its impacts  



## State of the art

In 1996, Moti Yung and Adam Young worked on the notion of  Secretly Embedded Trapdoor with Universal Protection (SETUP). They wanted to show the threats one can encounter when using a blackbox device such as smartcards and more recently mobile phones. Their article has refined the existing concepts of SETUP and provided new definitions of them. In addition, they proved that there are attacks that can leak the secret key of a blackbox system without the use of subliminal channels. With this paper and the proofs they made, Yung and Young introduced the concept of kleptography. 

As we will see further, what Yung and Young have showed is that kleptographic attacks can be considered as asymmetric backdoors. An attacker who implements the backdoor into a cryptosystem or cryptographic protocol is the only one who actually can have use of it. Furthermore, they showed that the output of that subverted cryptosystem is what they call *computationally indistinguishable* compared to a faithful output. The asymmetric aspect also implies that even if anyone succeeds into reverse-engineering the subverted system, he can find that it's compromised but will not be able to use it, where a classic symmetric backdoor can be in turn used after its discovery.

The implications of their results were great but at the time only a very few of academics believed in them. it was considered more of a theoretical issue than a real threat. This was until 2013 with the Dual_EC_DRBG controversy. 

The pseudorandom number generator was initially published in 2006 by the NIST and was intended to have a security proof. Since then a lot of researchers highlighted the multiple flaws present in the algorithm architecture and two cryptologists of Microsoft, Dan Shumow and Niels Ferguson, warned of the possible existence of a backdoor [^fn1]. In spite of this Dual_EC_DRBG has been standardized and implemented in multiple libraries like RSA BSAFE or OpenSSL. All suspicions will be proven true when finally several internal NSA documents will be leaked following the Snowden affair and will indicate the existence of the SIGINT project, thus proving the existence of the famous backdoor in the Dual_EC_DRBG algorithm and the very important role that the intelligence agency played in the standardization process. 

From 2014 onwards, the game has changed and many cryptologists are now looking into kleptography and various attacks and concepts are emerging. Moreover, there is finally a real interest in how to protect against kleptographic attacks[^fn2] and this even for cryptographic systems based on post-quantum and quantum algorithms[^fn3].



## Kleptography



### General definition

As described by Yung and Young, kleptography is: *The science of stealing information securely and subliminally from black-box cryptographic implementations*.  

This quote does not seem like much but she includes a lot of very important notions about kleptography. In this chapter we will deconstruct this definition and show how kleptography is articulated on the double link between the ease an attacker has to steal information from a victim, to hide their malicious activity and the impossibility of a lambda user to realize it or even to do the same.



### SETUP

Yung et Young designed the mechanism of SETUP (Secretly Embedded Trapdoor with Universal Protection) to perform kleptographic attacks. As described, one of the most important property of those attacks is the secrecy and the subliminality. The purpose of the SETUP mechanism is for an attacker to obtain information of the user's private key in a way that the user does not realize it or the attacker does not get caught. The SETUP does not leak information directly, it uses public parameters to hide private key information in it in a way only the person who has set the system up can recover it. 



#### SETUP definition

A more formal definition as been given by Yung and Young in their article [^fn4]:

> Assume that C is a black-box cryptosystem with a publicly known specification. A (regular) SETUP mechanism is an algorithmic modification made to C to get C’ such that:
>
> 1. The input of C’ agrees with the public specifications of the input of C .
> 2. C’ computes efficiently using the attacker’s public encryption function E (and possibly other functions as well), contained within C’.
> 3. The attacker’s private decryption function D is not contained within C‘ and is known only by the attacker.
> 4. The output of C‘ agrees with the public specifications of the output of C. At the same time, it contains published bits (of the user’s secret key) which are easily derivable by the attacker (the output can be generated during key-generation or during system operation like message sending).
> 5. Furthermore, the output of C and C’ are polynomially indistinguishable to everyone except the attacker.
> 6. After the discovery of the specifics of the setup algorithm and after discovering its presence in the implementation (e.g. reverse-engineering of hardware tamper-proof device), users (except the attacker) cannot determine past (or future) keys.



If we take this definition point by point, we can bring up several things:

- The first point shows that a user must be able to use C' in the same way as he uses C. This means that the parameters taken as input by C' must not be different from C otherwise it could make the user suspicious.
- The second point implies that the computation time of C' does not differ significantly from that of C. This is important because a user may feel that something is wrong if C' takes for example twice as much time as C.
- According to the third point, since only the attacker knows and has access to a decryption function D, only he can decrypt the leaked information.
- The form of the output of the two algorithms must not be different, if the user expects, for example, a 256 bits length output, then the output of C' must also be 256 bits long for the fourth point. In addition, the attacker must be able to retrieve the hidden information from the user's key.
- In fifth, a user must not be able to distinguish the output of C and C' in polynomial time with reasonable computational capacity.
- Finally, if the user discovers that the system is contaminated using reverse-engineering, it is still impossible for the user to recover past or future information from the private key using his study of the system. 

It is important to note that for Yung and Young, this last point is really only important for the formal definition of what they call a *strong SETUP* and not for *regular SETUP* as seen previously.



#### Weak SETUP definition

> A weak setup is a regular setup except that the output of C and C‘ are polynomially indistinguishable to everyone except the attacker and the owner of the device who is in control (knowledge) of his or her own private key (i.e, requirement 5 above is changed).

As Yung and Young say in their paper [^fn4], this form of SETUP may seem insecure, and indeed it is in the sense that a user in possession of the blackbox device can distinguish a genuine output from a contaminated one. But in reality, it implies that this same user manages to find out how to detect it by his own means. Moreover, it also implies that the user is aware that this kind of attack exists, otherwise he won't even suspect it. For these reasons, this type of SETUP can be useful as we can see **(EXAMPLE SIGNATURE EL GAMAL?)**



#### Strong SETUP definition

> A strong setup is a regular setup, but in addition we assume that
> the users are able to hold and fully reverse-engineer the device after its past usage and before its future usage. They are able to analyze the actual implementation of C’ and deploy the device. However, the users still cannot steal previously generated/future generated keys, and if the setup is not always applied to future keys, then setup-free keys and setup keys remain polynomially indistinguishable.



#### Summary of SETUP types

Each of these types can be seen as a security level of a SETUP, so it seems important to summarize the main properties distinguishing them in order to allow a finer analysis of existing attacks that we will see later.

| Type    | Important properties                                         |
| ------- | ------------------------------------------------------------ |
| Weak    | Only the user of the device can distinguish an output from C and C' in a polynomial time and knowing the private key |
| Regular | Even with the private key, the user of the device cannot distinguish an output from C and C' in a polynomial time |
| Strong  | With a complete understanding of how the system works and an access to all existing keys, the user will not be able to recover past and future keys or distinguish an output from C and C' |



#### Leakage bandwidth

As explained before, an attacker uses the public parameters of a user in order to recover the private key. But as we will see, it is not always possible to obtain a ratio of 1 set of public parameters for 1 exfiltration, it is indeed sometimes necessary to have access to 2 or more public keys. This is what Yung and Young call *leakage bandwidth* and they define it as follows[^fn4]:  

> A (m, n)-leakage scheme is a SETUP mechanism that leaks m keys/secret messages over n keys/messages that are output by the cryptographic device (m ≤ n).



This means if an attacker requires a public key to recover a private key, the system is a (1,1)-leakage scheme. In the same way, if an attacker needs 3 encrypted messages to be sent to get the private key, it implies the system is a (1,3)-leakage scheme.



#### SETUP RSA

To illustrate the notion of leakage bandwidth in **leakage bandwidth**, we can take a relatively simple SETUP mechanism in RSA. Let's suppose Alice and Bob try to communicate securely with RSA. Eve is the passive attacker who has contaminated the RSA system and that system is being used by the two others. Thus let (d,n) and (e,n) be the keys generated by Alice who will receive a message by Bob.

Let (D, N) and (E, N) be Eve's keys, respectively private and public keys. Eve's goal is to obtain Alice's private key d and at the end decrypt the communications.



##### Algorithm of the attack

Normally in RSA, we randomly generate the exponent e such that $1 < e < \phi(n)$ and $gcd(e, \phi(n)) = 1$. Same for the parameters p and q, so as e, they are intergers with a size of k so that they are generated from $\{ 0, 1\}^k$. Here the idea of the attack is to derivate the value of the Alice's exponent e from $p^E(mod N)$. Finally, d is as usual computed from e by taking its multiplicative inverse modulus $\phi(n)$. Here is a comparison between the normal RSA and the contaminated one:

| RSA key generation algorithm      | SETUP RSA key generation algorithm for victim | SETUP RSA key generation algorithm for attacker |
| --------------------------------- | --------------------------------------------- | ----------------------------------------------- |
| p, q                              | p, q                                          | P, Q                                            |
| n = p*q                           | n = p*q                                       | N = P*Q                                         |
| ϕ(n) = (p − 1)(q − 1)             | ϕ(n) = (p - 1)(q - 1)                         | ϕ(N) = (P - 1)(Q - 1)                           |
| 1 < e < ϕ(n) and gcd(e, ϕ(n)) = 1 | e ≡ p^E (mod N) and gcd(e, ϕ(n)) = 1          | 1 < E < ϕ(N) and gcd(E, ϕ(n)) = 1               |
| d ≡ e^-1 (mod ϕ(n))               | d ≡ e^-1 (mod ϕ(n))                           | D ≡ E^-1 (mod ϕ(N))                             |
| return (d, n) and (e, n)          | return (d, n) and (e, n)                      | return (D, N) and (E, N)                        |



Because of how Alice's exponent is generated, Eve can easily factor modulus n by computing $p \equiv e^D \mod(N) = (p^E)^D \mod(N) = p \mod(N)$  since the parameter n is public. Then she can compute $\phi(n)$ and finally find $d \equiv e^-1 \mod(\phi(n))$, Alice's private key and decrypt all messages Bob sends to her. 

It is easy to understand that this example of SETUP is a (1,1)-leakage because Eve only needs to wait for one encryption of Bob to obtain the prime p. 

Voici le déroulement d'un échange de message entre Alice et Bob et la mise en place de l'attaque par Eve (voir **Indiquer index** pour le code correspondant): 

```python
######## ATTACKER ########
Eve generates her keys:
    P = 51749 and Q = 51407
    N = P · Q = 2660260843
    ϕ(N) = (P − 1)·(Q − 1) = 2660157688
    E = 21001
    D ≡ E^−1 ≡ 2449635233 (mod N) 

######## VICTIM ########
Alice generates her keys using contaminated system:
    p = 49537 and q = 38933
    n = p · q = 1928624021
    ϕ(n) = (p − 1)·(q − 1) = 1928535552
    e ≡ p^E ≡ 49537^21001 ≡ 2410382527 (mod N)
    d ≡ e^−1 ≡ 1180109119 (mod n) 

Bob wants to send the message: Hi!
Encoded message: 7210533 

Bob encrypts the message to send it to Alice
Encryption of 7210533:
    c = m^e mod(n) = 1471085067

Alice receives Bob's message. She decrypts it
Decryption of 1471085067:
    m = c^d mod(n) = 7210533

Eve attacks Alice's private key
######## SETUP ATTACK ########
    p ≡ e^D mod(N) ≡ 49537
Knowing p, we can factor n to compute q:
    q = n/p = 38933
    ϕ(n) = (p − 1)·(q − 1) = 1928535552
    d ≡ e^−1 ≡ 1180109119 (mod n) 

Decryption of 1471085067:
    m = c^d mod(n) = 7210533

Eve has decrypted Bobs message: 7210533
```



##### Security of the attack

Une critique que l'on peut faire à cette attaque est qu'elle n'est pas très réaliste compte tenu des valeurs que peut prendre l'exposant e, en effet, e est trop grand par rapport aux valeurs du module n. Cela implique donc dans notre scénario que si Alice s'attend à des valeurs plutôt petites de e, elle se rendra facilement compte de la supercherie. On peut le remarquer dans l'exemple de déroulement précédent, on voit que l'exposant vaut 2410382527 alors que n lui vaut 1928624021. Dans leur article [^fn5], Yung et Young font remarquer que c'est ce qui arrive dans le cas de PGP, l'exposant étant de l'ordre de 5 bits.







## Annexe



```python
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
```



[^fn1]: http://rump2007.cr.yp.to/15-shumow.pdf
[^fn2]: Security of Symmetric Encryption
[^fn3]: Subvert KEM to Break DEM:Practical Algorithm-Substitution Attacks on Public-Key Encryption
[^fn4]:  Kleptography: Using Cryptography Against Cryptography
[^fn5]:The Dark Side of “Black-Box’’ Cryptography or: Should We Trust Capstone?