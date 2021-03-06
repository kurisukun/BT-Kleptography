## Publishable summary



Since 2013 with the Snowden affair, we can easily imagine that intelligence agencies such as the NSA have placed us under permanent surveillance: all our secure communications, when they are not being listened to, can be thwarted and read by these agencies and all this without us being aware of it or being able to do anything. These threats are not new and have been studied for almost 25 years through the field of kleptography.
With the help of this work, we present the fundamental concepts of kleptography, from its creation by Yung and Young in 1997 to today. To do so, in a first step, the mechanisms of Secretly Embedded Trapdoor with Universal Protection (SETUP) and Algorithm Substitution Attack (ASA) are formally defined with their own underlying characteristics and consequences.
In a second step, several kleptographic attacks against known and commonly used encryption schemes and cryptographic protocols such as RSA, Diffie-Hellman are studied. Each attack is then implemented in Sage to show how easy it is to deploy these attacks.
Finally we will have a presentation of the main countermeasures listed in the literature.





## Introduction

In our modern, ultra-connected world, we readily imagine that the world's great powers have eyes and ears everywhere, that *1984* is no longer as fictional as it was less than half a century ago, and that the shadow of *Big Brother* is becoming ever more prominent. A world where our communications, even though encrypted, could be thwarted and read by malicious people without us even realizing it. Such techniques exist and a new field of study that looks into the subject was born in 1997: kleptography. This will be the subject of this thesis.



## Specifications

### Problematic

Black-box devices are very common: smartcards, telephones, proprietary software, the list is long. The average person imagines that an attack on such devices is possible: indeed, a clumsy design of the device with weak cryptographic parameters, a poorly done programming can represent a considerable danger for these devices. An erroneous use of the device by the user can represent a threat and allow an attacker to seize possible private information. But what if the device itself is malicious? What if the malicious manufacturer had implemented a method for the device to do what it was created to do, but behind the scenes, the manufacturer can, at any time, retrieve the cryptographic keys, decrypt the user's communications and spy on him as he pleases? 

By asking all these questions, we will dive into a field of cryptography little known to the general public. Since the Snowden affair, people are a little more aware of the involvement of government agencies and the stakes of data encryption, but they are not fully aware of what all this field really implies and the consequences on our use of computer technology in general. The purpose of this thesis is therefore to recall the important definitions of kleptography, illustrate some of the attacks and list some of the possible defenses.



### Goals:

- Study and presentation of the general concepts of the kleptography. This means showing its evolution through time (what has changed since 2013), explaining the different concepts (ASAs, SETUP attacks, contaminating algorithms and implementations of protocols) and which are the ways we can protect ourselves from it very comprehensively
- Implement kleptographic attacks
- Use the attacks in a threat scenario in a way an informed and uninformed public can understand kleptography and its impacts  



## State of the art

In 1996, Moti Yung and Adam Young worked on the notion of  Secretly Embedded Trapdoor with Universal Protection (SETUP) [^fn5]. They wanted to show the threats one can encounter when using a black-box device such as smartcards and more recently mobile phones. At that time, the article was an attempt to warn about the risks of the black-box cryptography. Indeed, in the 90's, an American governmental project called Capstone was strongly talked about. This project aimed at developing a cryptographic standard for the general public as well as the government but met a lot of resistance from its potential users who saw it as an attempt by the American government to spy on its citizens[^fn13] due to the fact that the design of the proposed algorithm was classified so no one could review it. For many people, this was seen as a threat since the black-box aspect can not be trusted. As can be seen in the title of their article: "Should we trust Capstone?", Yung and Young were determined to demonstrate this. In addition, they proved that there are attacks that can leak the secret key of the black-box system and the user would not be able to notice it. Then in 1997[^fn4] with the proofs they made, Yung and Young introduced the concept of kleptography by creating types of SETUP attacks and defining the concept of bandwidth leakage which permits to measure the capacity of a SETUP attack to leak private information. 

As we will see further, what Yung and Young have showed is that kleptographic attacks can be considered as asymmetric backdoors. An attacker who implements the backdoor into a cryptosystem or cryptographic protocol is the only one who actually can have use of it. Furthermore, they showed that the output of that subverted cryptosystem is *computationally indistinguishable* compared to a faithful output. The asymmetric aspect also implies that even if anyone succeeds into reverse-engineering the subverted system, he can find that it's compromised but will not be able to use it, where a classic symmetric backdoor can be in turn used after its discovery.

The implications of their results were great but at the time only academics believed in them. it was considered more of a theoretical issue than a real threat. This was until 2013 with the Dual_EC_DRBG controversy. 

The pseudorandom number generator was initially published in 2006 by the NIST and was intended to have a security proof. Since then a lot of researchers highlighted the multiple flaws present in the algorithm architecture and two cryptologists of Microsoft, Dan Shumow and Niels Ferguson, warned of the possible existence of a backdoor [^fn1]. In spite of this Dual_EC_DRBG has been standardized and implemented in multiple libraries like RSA BSAFE or OpenSSL. Of course, no one to date has been able to prove that the backdoor was intentionally placed by the NSA. However, studies have shown that an exploitation of the standard is quite possible in the TLS standard [^fn8], especially the fact that the Extended Random TLS extension[^fn10] is supported would make it even easier to exploit the vulnerability, which still raises suspicions about the malicious and intrusive nature of the information agency. The doubt is reinforced when we know that the agency has made secret contracts[^fn9] with companies to ensure the use of Dual_EC_DRBG in their software, allowing them to ensure the use of this standard and thus increase their possible fields of attack. Finally, the draft has been withdrawn by the NIST from its draft guidance and a recommendation of switching from Dual_EC_DRBG to one of the three remaining algorithms that the organism has already approved has been made. 

From 2014 onwards, the game has changed and many cryptologists are now looking into kleptography and various attacks and concepts are emerging. Moreover, there is finally a real interest in how to protect against kleptographic attacks.

The renewed interest was mainly due to an article by Bellare, Paterson and Rogaway who later developed the possibility of mass surveillance through the concept of algorithm substitution attacks (ASAs)[^fn2]. Unlike SETUPs, which apply to asymmetric cryptographic standards and how to recover private information using public information (such as public keys), ASAs were originally aimed at symmetric encryption schemes and at recovering information through the ciphertext output. The aim is again to substitute the encryption algorithm with a subverted version created by an adversary. 

Subsequently, in 2015, Dagabriele, Farshim and Poettering redefined the security notion of the ASA model by simplifying the assumption that not all ciphertexts that are output by the subverted algorithm need to be decryptable[^fn11]. In the same year, Bellare, Jaeger and Kane [^fn11] again improved the model by strengthening the notion of undetectability by considering detectors with more capabilities in manipulating the internal states of subverted algorithms. A study of the relationship between ASA and steganography was made and allowed to extract the existence of universal ASAs which work without knowledge of the internal implementation of the underlying cryptographic primitive as long as this one integrates enough entropy, i.e. adds enough randomness in the internal state and is de facto not deterministic.

Latest results[^fn3] try to integrate ASAs in the public key encryption systems. This implies taking up the work of Yung and Young on the SETUP mechanism but attacking instead the encryption operation itself rather than the key generation.

Throughout these years of research, work on how to counter kleptographic attacks has also been carried out and many concepts have emerged, some of which will be presented in this thesis although they remain very theoretical for the moment.  





## Theoretical introduction

In order to enable the reader to understand the main part of this thesis, a theoretical introduction to some of the concepts discussed is given such as some theoretical reminders on the theory of numbers, a presentation of the concepts of difficult problems as well as that of stateful encryption.


### Terminology 

A first thing that must be discussed here is the name given to the classical figures of cryptology. Each figure starting with a different letter of the alphabet allows to represent an exchange between one or more actors more easily than if it was designated by a simple letter. Each character has a specific role in a scenario. Here is a list of the actors that will be used in this thesis:



- Alice and Bob: they represent the legitimate users. Usually Alice wants to send a message to Bob and she can receive his response.
- Carol: she represents usually the third participant in an exchange. 
- Eve: she represents an eavesdropper (passive listener) which can listen to Alice and Bob exchanges but can not modify them.



Despite the abundance of characters, we will stick to this list despite the interest that some may have in cryptography, because we will see, kleptographic attacks are perpetrated by a passive adversary who only listens to the exchanges between two people. 



### Number theory

Asymmetric cryptography is based on operations that use number theory and all the attacks presented in this thesis use these notions. Some very basic topics such as what a prime number is, coprimes, the notion of group or the Euclidean algorithm are omitted here. Of course, we will always work here with the sets N or Z unless specified since they are the predominant in cryptography.



#### Congruence

> Let n be a fixed positive integer. Two integers a and b are said to be congruent modulo n, symbolized by 
>
> a ??? b (mod n). 
>
> 
>
> if n divides the difference a - b; that is, provided that a - b = kn for some integer k. 

This definition for congruence can be found in [^fn24].

For example, let a = 46 and n = 6. This gives a ??? 4 (mod 6). Note that this is very similar to the division with reminder since a = 46 = 7 ?? 6 + 4. We conclude that finding the congruence of a and n is equivalent to finding the reminder of the division a/n.  



#### Quadratic residues



> Let p be an odd prime and gcd(a, p) = 1. If the quadratic congruence x^2 ??? a (mod p) has a solution, then a is said to be a quadratic residue of p. Otherwise, a is called a quadratic nonresidue of p. 

This definition comes from[^fn24].

The important point to remember is that if a ??? b (mod p), then a is a quadratic residue of p if and only if b is a quadratic residue of p. This means that we only need to observe the quadratic property of the numbers that are smaller than p to determine that of any other integer. 

Let's consider here the prime number p = 13. To find the list of the quadratic residues of 13, we need to find which integer in {1, 2, ..., 12} satisfy the congruence:

 x^2 ??? a (mod 13).

The squares are:

1^??? 12^2 ??? 1 

2^2 ??? 11^2 ??? 4 

3^2 ??? 10^2 ??? 9

4^2 ??? 9^2 ??? 3 

5^2 ??? 8^2 ??? 12

6^2 ??? 7^2 ??? 10.

What this means is that the set of the quadratic residues is {1, 3, 4, 9, 10, 12} and the set of the non-residues is {2, 5, 6, 7, 8, 11}.  



#### Generators of a group



>  A set of generators (g_1, ..., g_n) is a set of group elements such that possibly repeated application of the generators on themselves and each other is capable of producing all the elements in the group. Cyclic groups can be generated as powers of a single generator.

This definition comes from [^fn26].

In more concrete terms what this definition tells us is that if one can find an integer g such that taking the n powers of g gives us all the possible elements in the group, we say that g is a generator since it can generate all the possible values and the group has the property of being cyclic.

For example, let n = 5 then  Z^{???}{5} = {1, 2, 3, 4}. Since:

2^1 ??? 2 (mod 5)

2^2 ??? 4 (mod 5)

2^3 = 8 ??? 3 (mod 5)

2^4 = 16 ??? 1 (mod 5)

it comes that 2 is a generator of the group. With the same reasoning it comes that 4 is not a generator:

4^1 ??? 4 (mod 5)

4^2 = 16 ??? 1 (mod 5)

4^3 = 64 ??? 4 (mod 5)

4^4 = 256 ??? 1 (mod 5)

because it only generates the elements 1 and 4.



### Hard problems

The most common and modern cryptographic schemes rely on the fact that some problems are difficult to solve in a relatively small amount of time. So the cryptosystem is secure in the way that there is no algorithm which solves the mathematical hard problem within a reasonable length of time but the complexity still depends on which mathematical structure is used for the problem or the size of the chosen parameters. For example, the prime factorization is a difficult problem if the size of the integer to be decomposed decomposed is big enough and depends on the accessible calculation power. 



#### Discrete log problem

> The problem of finding the power 0< x <phi(n), if it exists, which satisfies the congruence r^{x} ??? y (mod n) for given r, y, and n. The exponent x is said to be the discrete logarithm of y to the base r, modulo n.

This definition comes from [^fn24].

The discret log problem is the base of several public key cryptosystems as Diffie-Hellman key exchange and El Gamal encryption. In general, there is no efficient known algorithm for computing the discrete logarithm. There is some algorithms like the Baby-Step Giant-Step or Pohlig-Hellman that can solve it but not in a polynomial time which can be sumed up by *not fast enough*. In certain cases, the discret log problem can be solved easily but it's not the case for the cryptosystems covered in this thesis.  

For example, for the group Z^{???}{5}, if g = 2, finding the discrete logarithm is finding the smallest exponent x such that 2^x  ??? 3 (mod 5), which in this case is x = 3 since:

2^3 = 8 ??? 3 (mod 5).

But for large modulus and values, finding this exponent is difficult.



#### Computational Diffie-Hellman assumption

> Let g be a group of order q. The computational Diffie-Hellman assumption (CDH assumption) is defined as given (g, g^a, g^b), for a randomly chosen generator g and a, b in {1, 2, ..., q-1}, it is computationally intractable to compute the value g^{ab}.

This definition comes from [^fn25].

What the problem says is that there is no known algorithm which takes in input g, g^a and g^b and outputs g^{ab} efficiently. It does not mean the problem is impossible, it means that in practical (understand it by with limited computation power) it is not feasible.

In the case of a Diffie-Hellman key exchange, it means that Eve the eavesdropper can observe the values g^x and g^y but is not capable to compute g^{ab} otherwise she would be able to compute the shared secret thus violating the confidentiality of the protocol. 

This resolution of this problem is very related to the one of the discrete log problem.  



### Stateful encryption

Encryption may be sometimes a quiet heavy operation in term of computational burden or volume of transmitted data in recurrent communications between two entities. This is why stateful encryption may represent a judicious choice: since some data is shared (a packet, a session key, a block of information), there's no need to recompute everything from the beginning for every communication chunk. Bellare, Kohno and Shoup [^fn15] showed this mechanism can be used to reduce the overhead of encrypting data directly with asymmetric schemes, El Gamal being an example. 

So a encryption scheme E is said stateful if its output does not consist of a ciphertext and a state ?? but only a ciphertext. If ?? is assumed to always have the same value (let's say 0), then the scheme is said stateless. 





## Kleptography



### General definition

As described by Yung and Young [^fn5] [^fn4], kleptography is: "The science of stealing information securely and subliminally from black-box cryptographic implementations".  

This quote does not seem like much but she includes a lot of very important notions about kleptography. In this chapter, we will deconstruct this definition and show how kleptography is articulated on the double link between the ease an attacker has to steal information from a victim, to hide their malicious activity and the impossibility of a lambda user to realize it or even to do the same.



### SETUP

Yung and Young designed the mechanism of SETUP (Secretly Embedded Trapdoor with Universal Protection) to perform kleptographic attacks. As described, two of the most important property of those attacks is the secrecy and the subliminality. The purpose of the SETUP mechanism is for an attacker to obtain information of the user's private key in a way that the user does not realize it or the attacker does not get caught. The SETUP does not leak information directly, it uses public parameters to hide private key information in it. The manufacturer who has set the system up is the only one who can recover it. 



#### SETUP definition

A more formal definition as been given by Yung and Young in their article [^fn4]:

> Assume that C is a black-box cryptosystem with a publicly known specification. A (regular) SETUP mechanism is an algorithmic modification made to C to get C??? such that:
>
> 1. The input of C??? agrees with the public specifications of the input of C .
> 2. C??? computes efficiently using the attacker???s public encryption function E (and possibly other functions as well), contained within C???.
> 3. The attacker???s private decryption function D is not contained within C??? and is known only by the attacker.
> 4. The output of C??? agrees with the public specifications of the output of C. At the same time, it contains published bits (of the user???s secret key) which are easily derivable by the attacker (the output can be generated during key-generation or during system operation like message sending).
> 5. Furthermore, the output of C and C??? are polynomially indistinguishable to everyone except the attacker.
> 6. After the discovery of the specifics of the setup algorithm and after discovering its presence in the implementation (e.g. reverse-engineering of hardware tamper-proof device), users (except the attacker) cannot determine past (or future) keys.

If we take this definition point by point, we can bring up several things:

1. The first point shows that a user must be able to use C' in the same way he uses C. This means that the parameters taken as input by C' must not be different from C otherwise it could make the user suspicious.
2. The second point implies that the computation time of C' does not differ significantly from that of C. This is important because a user may feel that something is wrong if C' takes for example twice as much time as C.
3. According to the third point, since only the attacker knows and has access to a decryption function D, only him can decrypt the leaked information.
4. The form of the output of the two algorithms must not be different, if the user expects a 256 bits length output for example, then the output of C' must also be 256 bits long for the fourth point. In addition, the attacker must be able to retrieve the hidden information from the user's key.
5. In fifth, a user must not be able to distinguish the output of C and C' in polynomial time with reasonable computational capacity.
6. Finally, if the user discovers that the system is contaminated using reverse-engineering, it is still impossible for the user to recover past or future information from the private key using his study of the system. 

Note that for Yung and Young, this last point is really only important for the formal definition of what they call a *strong SETUP* and not for *regular SETUP* as seen previously.



#### Weak SETUP definition

> A weak setup is a regular setup except that the output of C and C??? are polynomially indistinguishable to everyone except the attacker and the owner of the device who is in control (knowledge) of his or her own private key (i.e, requirement 5 above is changed).

As Yung and Young say in their paper [^fn4], this form of SETUP may seem insecure, and indeed it is in the sense that a user in possession of the blackbox device can distinguish a genuine output from a contaminated one. But in reality, it implies that this same user manages to find out how to detect it by his own means. Moreover, it also implies that the user is aware that this kind of attack exists, otherwise he won't even suspect it. For these reasons, this type of SETUP can be useful as we can see in the SETUP in El Gamal signature scheme. 



#### Strong SETUP definition

As we have seen, in regular SETUP devices, we assume that the cryptosystem acts as a black-box with the exception of the condition 6.  This last condition raises an interesting property to note. This means if we have two different algorithms,a legit one and a contaminated one, the respective outputs of the algorithms C and C' are polynomially indistinguishable, and according to Yung and Young, this a necessary condition to obtain polynomial indistiguishability between the different past and future keys. From there, for the definition of the strong SETUP, Yung and Young assume that the contaminated device sometimes uses the normal algorithm and sometimes the SETUP. We therefore have [^fn4]:  

> A strong setup is a regular setup, but in addition we assume that the users are able to hold and fully reverse-engineer the device after its past usage and before its future usage. They are able to analyze the actual implementation of C??? and deploy the device. However, the users still cannot steal previously generated/future generated keys, and if the setup is not always applied to future keys, then setup-free keys and setup keys remain polynomially indistinguishable.

Again, this means that an user who has totally reverse-engineered the contaminated device but didn't obtain the attacker's key and random choices. Even if he manages to know which functions and fixed values are in the code and all of this done before and after every use of the device, the user would still  not be able to recompute the keys that were generated. Even worse, as the strong SETUP sometimes uses the normal algorithm and sometimes not, the user does not know which generated keys contain some information as it is assumed that the device doesn't keep information of when the SETUP is used or not used. 

This form of SETUP is much safer than the weak version since the system doesn't need to be a black-box cryptosystem. 



#### Summary of SETUP types

Each of these types can be seen as a security level of a SETUP, so it seems important to summarize the main properties distinguishing them in order to allow a finer analysis of existing attacks that we will see later.

| Type    | Important properties                                         |
| ------- | ------------------------------------------------------------ |
| Weak    | Only the user of the device can distinguish an output from C and C' in a polynomial time and knowing the private key |
| Regular | Even with the private key, the user of the device cannot distinguish an output from C and C' in a polynomial time |
| Strong  | With a complete understanding of how the system works and an access to all existing keys, the user will not be able to recover past and future keys or distinguish an output from C and C' |

To summarize, let's take a small example with three black-box cryptosystems D1, D2 and D3 and let's consider D1 has a weak SETUP, D2 has a regular SETUP and D3 has a strong SETUP.

If the user of D1 realizes the subversion, he can with his private key also use this subversion as the attacker would. He can thus realize when a SETUP attack is taking place with his black-box device and distinguish the output from another legitimate one. For example, a fraudulent cryptographic module that generates RSA keys, the user would immediately see that the generated key is not perfectly random compared to a normal RSA key.  However, this is not the case for D2 and D3.
For D2, the device is used exactly like a normal device. If we take the example from before, the user can use the module as if it were perfectly legitimate, but would not be able to realize the subversion. However, if the user were to discover the deception and could obtain the internal state of his module, he could easily find all the attacks that have been or will be perpetrated.This is not the case for D3.



#### Leakage bandwidth

As explained before, an attacker uses the public parameters of a user in order to recover the private key. But as we will see, it is not always possible to obtain a ratio of one set of public parameters for one exfiltration, it is indeed sometimes necessary to have access to two or more public keys. This is what Yung and Young call *leakage bandwidth* and they define it as follows[^fn4]:  

> A (m, n)-leakage scheme is a SETUP mechanism that leaks m keys/secret messages over n keys/messages that are output by the cryptographic device (m ??? n).



This means if an attacker requires a public key to recover a private key, the system is a (1,1)-leakage scheme. In the same way, if an attacker needs three encrypted messages to be sent to get the private key, it implies that the system is a (1,3)-leakage scheme.

Throughout this work, we will address the leakage bandwidth issue for each discussed SETUP attack. This will allow us to judge the effectiveness of the SETUP attack.



### SETUP in RSA

#### SETUP in RSA key generation I

Let's suppose Alice and Bob try to communicate securely with RSA. Eve is the passive attacker who has contaminated the RSA system and that system is being used by the two others. Thus let (d,n) and (e,n) be the keys generated by Alice who will receive a message by Bob.

Let (D, N) and (E, N) be Eve's keys, respectively private and public keys. Eve's goal is to obtain Alice's private key d and in the end decrypt the communications.



##### Algorithm of the attack

Normally in RSA, we choose $e$ to be equal to 65'537 in practice, but sometimes it happens that we randomly generate the exponent e such that 1 < e < ??(n) and gcd{(e, ??(n))} = 1. Same for the parameters p and q, so as e, they are intergers with a size of k so that they are generated from {0, 1}^k. Here the idea of the attack is to derivate the value of Alice's exponent e from p^E(mod N). Finally, d is as usual computed from e by taking its multiplicative inverse modulus ??(n). Here is a comparison between the normal RSA and the contaminated one:

| RSA key generation algorithm      | SETUP RSA key generation algorithm for victim | SETUP RSA key generation algorithm for attacker |
| --------------------------------- | --------------------------------------------- | ----------------------------------------------- |
| p, q                              | p, q                                          | P, Q                                            |
| n = p*q                           | n = p*q                                       | N = P*Q                                         |
| ??(n) = (p ??? 1)(q ??? 1)             | ??(n) = (p - 1)(q - 1)                         | ??(N) = (P - 1)(Q - 1)                           |
| 1 < e < ??(n) and gcd(e, ??(n)) = 1 | e ??? p^E (mod N) and gcd(e, ??(n)) = 1          | 1 < E < ??(N) and gcd(E, ??(n)) = 1               |
| d ??? e^-1 (mod ??(n))               | d ??? e^-1 (mod ??(n))                           | D ??? E^-1 (mod ??(N))                             |
| return (d, n) and (e, n)          | return (d, n) and (e, n)                      | return (D, N) and (E, N)                        |



Because of how Alice's exponent is generated, Eve can easily factor modulus n by computing p ??? e^D (mod N) = (p^E )^D (mod N) = p (mod N)  since the parameter n is public. Then she can compute ??(n) and finally find d ??? e^{-1} (mod ??(n)), Alice's private key, and decrypt all messages Bob sends her. 

It is easy to understand that this example of SETUP is a (1,1)-leakage because Eve only needs to wait for one encryption from Bob to obtain the prime p. 

Here is the sequence of a message exchange between Alice and Bob and the implementation of the attack by Eve (see **Indicate index** for the corresponding code): 

**Example 1:**

```python
######## ATTACKER ########
Eve generates her keys:
    P = 51749 and Q = 51407
    N = P ?? Q = 2660260843
    ??(N) = (P ??? 1)??(Q ??? 1) = 2660157688
    E = 21001
    D ??? E^???1 ??? 2449635233 (mod N) 

######## VICTIM ########
Alice generates her keys using contaminated system:
    p = 49537 and q = 38933
    n = p ?? q = 1928624021
    ??(n) = (p ??? 1)??(q ??? 1) = 1928535552
    e ??? p^E ??? 49537^21001 ??? 2410382527 (mod N)
    d ??? e^???1 ??? 1180109119 (mod n) 

Bob wants to send the message: Hi!
Encoded message: 7210533 

Bob encrypts the message to send it to Alice
Encryption of 7210533:
    c = m^e mod(n) = 1471085067

Alice receives Bobs message. She decrypts it
Decryption of 1471085067:
    m = c^d mod(n) = 7210533

Eve attacks Alices private key
######## SETUP ATTACK ########
    p ??? e^D mod(N) ??? 49537
Knowing p, we can factor n to compute q:
    q = n/p = 38933
    ??(n) = (p ??? 1)??(q ??? 1) = 1928535552
    d ??? e^???1 ??? 1180109119 (mod n) 

Decryption of 1471085067:
    m = c^d mod(n) = 7210533

Eve has decrypted Bobs message: 7210533
```



##### Security of the attack

One criticism that can be made of this attack is that it is not very realistic given the values that the exponent e can take. Indeed, e is too large compared to the values of the modulus n. In our scenario this implies that if Alice expects rather small values of e, she will easily realize the deception. We can notice it in the previous example, we see that the exponent is 2410382527 while n is 1928624021. In their article [^fn5], Yung and Young point out that this is what happens in the case of PGP, the exponent being of the order of 5 bits. Nowadays it is unimaginable to have such a small amount of bits for the exponent, most of the time the exponent is equal to 65537 but the values we get here in the attack are still too big not to be noticed.



### SETUP in El Gamal

#### SETUP El Gamal signatures

Yung and Young proposed a way to add a SETUP mechanism to the cryptosystem El Gamal both for its encryption method and for its signature method. It is this last one that will interest us here. 



The attacker's keys are generated as for a classical El Gamal signature and the public parameters of the attacker are also the ones of the user. In their SETUP in the El Gamal cipher, Yung and Young had made the cipher algorithm change these public parameters every time, which is less realistic than here where they remain constant. 



##### Algorithm of the attack

As for a classical El Gamal, we define a prime number p and a generator g of Z^*_p??? for the user and for the attacker. Then let X ??? {1, 2, ..., p-1} be the attacker's private key and Y ??? g^X (mod p) his public key. Let then x be the user's private key and y the corresponding public key generated as the attacker's one.   

Given the scenario where Alice wants to authenticate a message she sends, she will send the triplet (m, r, s) to Bob where m is actually the hash of the message and r and s form the signature. To perform this attack, Eve needs to get two consecutive signatures, two triplets (m1, r1, s1) and (m2, r2, s2), from Alice. These signatures are computed as follows:



1. Using the normal condition of El Gamal signature scheme, a random integer ki is randomly generated from {1, 2, ..., p-2} such that gcd(ki, p-1) = 1.

2. Then the first signature is computed as follows:

    ri ??? g^ki (mod p)
    si ??? ki^{???1} (mi ??? x ?? ri) (mod p???1),

   Then the program outputs the triplet (mi, ri, si)

   The step where s is calculated requires the calculation of the inverse of k. This computation is only possible because we have made sure by drawing k that gcd(k, p-1) = 1. 

3. The second signature is then computed in a slightly different way. Instead of choosing k{i+1} as before, Yung and Young choose its inverse to be a very specific value. So let c ??? Y^{ki} (mod p) and then they compute c^{-1}. The existence of the inverse of integer c is possible if and only if:

    gcd(c, p-1) = 1 																									   (1)

   Finally if the previous condition and:

   gcd(g^{k{i+1}, p-1)																								   (2)	

   then ki+1 is chosen to be congruent to c^-1 (mod p) and not randomly. The fact that c is used for calculating k{i+1} makes c ??? {1, 2, ..., p-2}. The choice of the upper bound that is p-2 and not p-1 is explained by the fact that if c = p-1, then we would have gcd(p-1, p-1) = p-1 != 1.

   

   If condition (1) and (2) are not satisfied, then ki+1 is randomly drawn such that ki+1 ??? {1, 2, ..., p - 2} and the normal El Gamal scheme is used instead, which implies that a proper signature is produced and can't be used by the attacker to recover Alice's private key.

4. Finally, the signature is computed as before but using the new values:

    r{i+1} ??? g^k{i+1} (mod p)
    s{i+1} ??? k{i+1}^{???1} (m{i+1} ??? x ?? r{i+1}) (mod p - 1)

   and the program outputs the triplet (m{i+1}, r{i+1}, s{i+1}).



##### Recovering the private key

Eve uses the two signatures  (mi, ri, si) and (m{i+1}, r{i+1}, s{i+1}) to obtain Alice's private key. First of all, the attacker computes:

ri^X ??? (g^{ki}) ^X ??? g^(ki X) = (g^X) ^ ki ??? Y^{ki} ??? c (mod p)											  (3)

where c is an integer included in {1, 2, ..., p-2}. 



Before showing how we find the key, we need to remember the given relation:

s{i+1} ??? k{i+1}^{-1}?? (m{i+1} ??? x ?? r{i+1}) (mod p - 1)  ??? c ??  (m{i+1} - x ?? r{i+1}) (mod p - 1)			  (4)



which we can rewrite as: 

s{i+1} ?? c^-1 ???  (m{i+1} - x ?? r{i+1}) (mod p - 1) 

-s{i+1} ?? c^-1 ???  x ?? r{i+1} - m{i+1} (mod p - 1) 																		    (5)



Now by combining the following calculation:

r{i+1}^-1 ?? (m{i+1} - s{i+1} ?? c^-1) (mod p - 1)																				(6)

and (5) and we now can obtain the private key:

r{i+1}^-1 ?? (m{i+1} + (x ?? r{i+1} - m{i+1})) 

r{i+1}^-1 ?? (m{i+1} -m{i+1} + x ?? r{i+1}) 

r{i+1}^-1 ?? (x ??  r{i+1}) ??? x (mod p - 1) 

For this to work, the attacker needs to inverse r{i+1} (mod p-1), and for the latter to exist, as before, we must show that gcd(r{i+1}, p) = 1. And given that k ??? c, then r{i+1} ??? g^k{i+1} ??? g^ {c^{-1}} (mod p). So from this, we have that:
gcd(g^ c^{-1} (mod p), p - 1) = 1

which explains the need for the condition (2). 

Therefore, when she does the calculations, Eve knows that if gcd(r{i+1}, p-1) =! 1, then k{i+1} =! c^{-1} and therefore she cannot use the signature pair to find the private key. 



In the **example 2**, we have a step-by-step example of the attack can be found. First, we show the different parameters being generated for Alice and Eve. Then we see the computation of the first signature (m1, r1, s1) by Alice and the verification of it by Bob. Alice signs an other message afterwards to send it to Bob and produces the triplet (m2, r2, s2) which is also verified by Bob. In the end, the sequence shows how Eve recovers Alice's private key x using both signatures previously calculated.  

**Example 2:**

```
######## Generation of parameters ########
    p = 2
    g = 2

######## ATTACKER  ########
Eve generates her keys using g = 2 and p = 4282531469 as parameters
    X = 863261721
    Y ??? g^X = 2^863261721 ??? 3384084900 (mod 4282531469)

######## VICTIM  ########
Alice generates her keys using g = 2 and p = 4282531469 as parameters
    x = 4252958629 (THIS IS WHAT WE WANT)
    y ??? g^x = 2^4252958629 ??? 88565237 (mod 4282531469)

Alice wants to send the message: HI
encoded message: 7273

Alice generates the first signature:
    Generation of k1 = 1318625155 such that gcd(k1, p-1) = 1
    r1 ??? g^k1 = 2^1318625155 ??? 1368264974 (mod 4282531469)
    s1 ??? k1^???1(m1 ??? x ?? r1 ) ??? 1048024771(7273 - 4252958629??1368264974) ??? 1049540629 (mod 4282531468)
Bob verifies the signature with (7273, 1368264974, 1049540629)
    g^m ??? 1001303893 (mod 4282531469)
    y^r ?? r^s ??? 1001303893 (mod 4282531469)
The signature corresponds: True
Alice now wants to send the message: OK
encoded message: 7975

Alice generates the second signature:
c ??? Y^k1 ??? 3384084900^1318625155 ??? 2498434343 (mod 4282531469)
    k2 ??? c^-1 ??? 2629132439 (mod 4282531468)
    r2 ??? g^k2 = 2^2629132439 ??? 2894982921 (mod 4282531469)
    s2 ??? k2^???1(m2 ??? x ?? r2 ) ??? 2498434343(7975 - 4252958629??2894982921) ??? 3974137686 (mod 4282531468)

Bob verifies the signature with (7975, 1368264974, 1049540629)
    g^m ??? 2466722170 (mod 4282531469)
    y^r ?? r^s ??? 2466722170 (mod 4282531469)
The signature corresponds: True
######## SETUP ATTACK ########
Eve attacks Alice private key: 
Key recovery: 7975  2894982921  3974137686
    She computes c ??? ri^X (mod 4282531469) ??? 1368264974^863261721 (mod 4282531469 ??? 2498434343 (mod 4282531469))
    x = r2^-1 (m2 - s2//c) = 2894982921^-1 (7975 - 3974137686//2498434343)
    Alice private key obtained: 4252958629
```

The code generating this sequence can be found here: **METTRE LIEN VERS LE CODE**.



##### Security of the attack

This attack still has a high chance of failing because of all the conditions 2 and 3 that we saw earlier. Indeed, let a and b be two random integers, then:

P(gcd(a, b) = 1) = 6/pi^2

The proof of this result can be found in  [^fn6]. Let's assume now that our randomly drawn integers are c and p-1. It means that P(gcd(c, p-1) = 1) = 6/pi^2, as well for g^ {c^{-1}} and p-1. So for the generation of a single pair of signatures, we have then:

P(gcd(c, p-1) = 1) and P(gcd( g^ {c^{-1}}, p-1) = 1) =  (6/pi^2)  ^2. 		(7)

This means Eve has approximatively 37% chance of getting an useful pair of signatures that allows to attack an user's private key, which is not that good. However, we can show that producing more signatures increases the chances of getting an useful pair of signatures. 

Let's assume that Eve wants to generate a bigger number of pairs of signatures, let that number be 10. The probability that all 10 pairs of signatures are not useful for Eve is given by:

P(10 pairs of signatures are not useful) = (1 - (6/pi^2) ^2) ^10 ??? 0.0099

by using the previous result (7).

This means that Eve has a probability of getting at least one useful pair out of 4 pairs of signatures, which is given by:

P(1 pair out of 4 pairs of signatures is useful) = 1 - (1 - (6/pi^2) ^2) ^10  ??? 1 - 0.0099  ??? 0.99.

which would greatly increase the chances of using the SETUP for Eve.



### SETUP in Diffie-Hellman

In their article[^fn4], Yung and Young explained that this SETUP attack would not follow the same concern as the previous ones. Previously, the objective was to produce an output that won't warn the user about the malicious nature of the device nor give him any chance of using his properties either. This is why each SETUP we have seen until now created a subliminal channel with a known bandwidth for leaking private information inside the output of the cryptosystem. This time, the approach uses a SETUP attack in the discrete log.   

Alice and Bob want to agree on a secret by using an insecure channel. For the recall, this is what the Diffie-Hellman allows to do. The protocol uses a large prime p and g a generator of Z*p as public parameters. Then to establish the shared secret, Alice and Bob randomly draw a private key x from {1, 2, ..., p-1} (as in El Gamal scheme) and compute their respective public key and send it to the other.

For this attack, Yung and Young assume that Alice needs a brand new key pair every time a connection is established in the channel and will therefore require Alice to have a different x private key for each different user she wants to exchange with. In our example, Alice will have the key x1_a to communicate with Bob and the key x2_a to communicate with Carol.



#### SETUP in Diffie-Hellman key exchange protocol

##### Algorithm of the attack

As it was described before, let's imagine that Alice and Bob want to communicate confidentially on a insecure channel so they use a Diffie-Hellman device to generate the required keys. The parameters p and g are kept constant in the device and it does not output anything else than the public key, the private key is secret. Finally let's assume that Alice's device has been contaminated by Eve, a malicious adversary. For this attack to be performed, Eve has written in Alice's device the following values: her private key Y, some constant integers a, b, and W and a cryptographically strong hash function H which outputs a hash value in {1, 2, ..., p-1}. 

The attack goes as follow:



1. For the first usage, x1 ??? {1, 2, ..., p-1} is chosen randomly. This will be Alice's private key. Then her public key is computed as:

   y1 ??? g^x1 (mod p) 										(1)

   and represents the output of the device. As Yung and Young say in their article, the value the private key x1 is stored for the next time the device will be used, and only this one time.

   Now that Alice's device has output the public key y1, she can send it to Bob who in turn has also generated its respective keys. After this, Alice and Bob can compute their shared secret which will permit them to communicate with confidentiality. But if we assume that Alice and Bob want to exchange their respective keys, or that Alice wants to send messages securely with a completely different user Carol, then Alice will need to go back to the key generation step one more time. 

2. For the second usage, the private key x2 is not randomly chosen, it is constructed with the use of multiple integers:

   - First of all, an integer t is chosen uniformly at random from {0, 1}. 

   - After that, the integer z is computed as:

     z ??? g^{x1-W??t} ?? Y^{-a??x1 - b} (mod p)   (2)

     with a, b and W the fixed integers previously mentioned.

   - Finally the hash function H is used to produce the new private x2:

     x2 = H(z)													(3)

     and followed by the new public key y2:

     y2 ??? g^x2 (mod p)									(4) 

   Because of how we generated x2, x1 has been put inside of it and the attacker only has to use both public keys to recover Alice's second private key.



##### Recovering the private key

Let y1 and y2 be Alice's public key that will allow Eve to get Alice's second private key. Let p and g be the public parameters for the Diffie-Hellman key exchange and a, b and W the fixed parameters that Eve knows because she's the one who chose them. Finally, Eve is the only person who knows the value of X, her private key. The recovery is performed as follows:



1. First Eve computed the value:

   r ??? y1^a ?? g^b (mod p). 									(5)

2. Then Eve uses this value in conjunction with y1, y2 and X to calculate:

   z1 ??? y1/r^X (mod p)											(6)

3. Then if 

   y2 ??? g^H(z1) (mod p)										  (7)

   then the program outputs H(z1) = x2 and the task is done.

4. Otherwise, Eve computes: 

   z2 ??? z1/g^W (mod p)											(8)

   which implies that y2 ??? g^H(z2) and then the program outputs H(z2) = x2.

   

Let's show that this result truly gives us the private key x2. For this, equations (1), (5) and (6) are used:

z1??? y1/r^X

???	??? g^x1 / (y1^a ?? g^b) ^X

???	??? g^x1 / ((g^x1 )^a ?? g^b) ^X

???	??? g^x1 / (g^{a??x1 + b} )^X

???	??? g^x1 ?? g^{-a??x1  - b}^X

???	??? g^x1 ?? ( g^X )^{-a??x1  - b}

???	??? g^x1 ?? Y^{-a??x1  - b} (mod p) 								(9)



As we can see, equation (9) is the same as equation (2) for t = 0 and implies that z1 = z and therefore x2 = H(z1). Also, note that condition (7) is explained by the fact that :

y2 ??? g^x2 ??? g^H(z) ??? g^H(z1) (mod p).

On the other hand, if the device were to have drawn t = 1, then an additional calculation has to be done by using equations (9) and (8):

z2??? z1 / g^W

???	??? (g^x1 ?? Y^{-a??x1  - b}) / g^W

???	??? (g^x1 ?? Y^{-a??x1  - b}) ?? g^-W

???	??? (g^{x1-W} ?? Y^{-a??x1  - b})

which is equal to equation (2) with t = 1 and implies that z2 = z and therefore x2 = H(z2). As before, note that the condition (3.25) is explained by the fact that:

 y2 ??? g^x2 ??? g^H(z) ??? g^H(z2) (mod p)

This shows us that this attack on the discrete log against the Diffie-Hellman key exchange protocol has a (1, 2)-leakage scheme. It requires to Eve to obtain two public keys from Alice to give her the possibility of getting her private key.



##### Use of a, b and W

An interesting point that remains to be raised before discussing the security of the attack is the reason for the existence of the integers a, b and W: to prevent the user who assumes that the system is contaminated from distinguishing its outputs from those of a normal system. Yung and Young showed that if Alice knows the internal structure of the contaminated device and knows how to inverse H by any manner, she can determine with a certain probability that a SETUP has been used:

Let's suppose Alice can choose the value of the exponents and assume that a, b and W are not used (i.e. a = 1, b = 0 and t = 0 so W is useless), we have:

z ??? g^x1 ?? Y^{-x1} 														(10)

If Alice generates two pairs of private and public keys, since she knows that H is an invertible function:

z ??? H^{-1}(x2)

Alice does not know the value of Y and X since the device acts like a black-box but she still can emit some hypothesis. Yung and Young introduce the result g^x1 / z which we may rewrite as: 

g^{x1} / z ??? g^{x1} / (g^x1 ?? Y^{-x1}) ??? Y^{x1} (mod p) 									(11) 

If the attacker's private key X is odd, it means we have two possibilities:

- If x1 is even, then (11) can be written as:

  Y^{x1} ??? Y^{2??x1'} ??? (Y^{x1'} )^2 (mod p) 

  which is by definition a quadratic residue modulo p.

- But if x1 is odd, then (11) can be rewritten as:

  Y^{x1} ??? Y^{2??x1' + 1} (mod p)

  which is a quadratic non-residue

But if X is even, it follows that:

- Y^{x1} ??? (g^X )^{x1} ??? (g^{2X'} )^{x1} ??? (g^{X??x1} )^2 (mod p)

  which implies that it's a quadratic residue regardless of the value of x1.



To resume, we now know that, in a contaminated system, Y^{x1} has a probability of 0.75 to be a quadratic residue and 0.25 for a non-residue. Compared to an uncontaminated system where the distribution of quadratic residuals is balanced[^fn7], the device modified by Eve is unbalanced. This means Alice has the possibility to determine if the device she's using is a contaminated one or not. She computes several private key pairs and calculates the result (11). If she finds out that there are significantly more quadratic residues than non-residues, she will have the certainty that her device is contaminated. 

In other words, the use of these fixed integers effectively prevents Alice from checking the quadratic residue property and thus prevents her from determining the true nature of the cryptosystem she uses.



In **example 3**, we have a step-by-step example of the attack. First we have the generation of the parameters for Alice, Bob and Eve with their respective pair of keys. Then in a second step Alice and Bob compute the shared secret so they can begin to communicate confidentially. Then Alice needs to generate an other pair of key, same for Carol, since they want to create a shared secret. We see how Alice's new private key is not drawn randomly but calculated.  Eve can now use her attack to compute for herself the shared secret Alice and Carol have in common. The code corresponding to this sequence can be found here: **METTRE LIEN VERS LE CODE**.



**Example 3:**

```
######## Generation of parameters ########
    p = 7
    g = 7

######## ATTACKER  ########
Eve generates her keys using g = 7 and p = 2932727519 as parameters
    X = 2593769209
    Y ??? g^X = 7^2593769209 ??? 1915266573 (mod 2932727519)

######## VICTIM  ########
- First signature: Alice wants to communicate with Bob -
Alice generates her keys using g = 7 and p = 2932727519 as parameters
    x1_a = 650788030 (What we are looking for)
    y1_a ??? g^x1_a = 7^650788030 ??? 974455017 (mod 2932727519)

Alice sends her public key to Bob
Bob generates her keys using g = 7 and p = 2932727519 as parameters
    x1_b = 2629330839
    y1_b ??? g^x1_b = 7^2629330839 ??? 1194475180 (mod 2932727519)

Bob sends his public key to Alice
Alice and Bob can now both compute the shared secret
    Alice by computing: s1 ??? y1_b^x1_a = 2097992111
    Bob by computing: s1 ??? y1_a^x1_b = 2097992111

- Second signature: Alice want to communicate with Carol -
Alice generates her keys using g = 7 and p = 2932727519 as parameters
    x2_a = 679829788 (This is what we are looking for)
    y2_a ??? g^x2_a = 7^679829788 ??? 2341042137 (mod 2932727519)

Alice sends her public key to Carol
Carol generates her keys using g = 7 and p = 2932727519 as parameters
    x1_c = 2162907609
    y1_c ??? g^x1_c = 7^2162907609 ??? 2359756352 (mod 2932727519)

Carol sends her public key to Alice
Alice and Carol can now both compute the shared secret
    Alice by computing: s2 ??? y1_c^x2_a = 1348808703
    Carol by computing: s2 ??? y2_a^x1_c = 1348808703
    
######## SETUP ATTACK ########
    r ??? y1_a^a ??g^b = 2282663174 (mod 2932727519)
    z ??? y1_a^a ??g^b = 2282663174 (mod 2932727519)
    Eve has obtained Alice's private key: True
    She can now use Carole's public key to compute the shared secret: s2 ??? y1_c^x2_a = 1348808703
```



##### Security of the attack

According to Yung and Young, this attack relies on two main issues. The first one is that for any other user than the attacker, no one should be able to detect if the SETUP mechanism is in use or not. The second one is that only the attacker has the ability to recover the private key x2, not even the user of the device. To prove that this attack solves these two problems, the authors have stated the respective claims:



> z is uniformly distributed in Zp.

To prove this, Yung and Young introduce three generators of Z*p:

g1 ??? g^{-Xb -W} (mod p),   g2 ??? g^{-Xb},    g3 ??? g^{1- aX}

Then by taking the result (2) previously seen we can rewrite it as:

z  ??? g^{x1 -Wt} ?? Y^{-ax1 - b}

???	??? g^{x1 -Wt} ?? (g^X )^{-ax1 - b}

???	??? g^{x1} ?? g^{-Wt} ?? g^{-aXx1} ?? g^{-Xb}

???	??? g^{-Xb - Wt} ?? g^{x1 - aXx1}

???	??? g^{-Xb - Wt} ?? g^{(1 - aX) x1}

???	??? gi ?? g3^{x1} (mod p) 										(12)

where i can be equal to 1 or 2. More specifically, if t = 0:

 gi = g^{-Xb} = g2 

and if t = 1

gi = g^{-Xb -W} = g1

Then as we know, since g1, g2 and g3 are all generators by hypothesis, we know we can write:

gi ??? g3^{u} (mod p)

for some integer u.     

Then if we substitute it into equation (12), it gives:

z ??? g3^{u} g3^{x1} (mod p)

??? g3^{u + x1} (mod p).

and since x1 is chosen at random in {1, 2, ..., p-1}, then z must be uniformly distributed in Zp.

> The Discrete Log SETUP is secure iff the DH problem is secure. 

For explanations about what the Diffie-Hellman problem represents, have a look at section **METTRE SECTION ICI**. What they explain here is if an user has a way to solve the Diffie-Hellman problem, the SETUP wouldn't stay secure and vice-versa. The proof goes as follows.

Suppose the existence of an oracle A that is able to solve the Diffie-Hellman problem. This is denoted by Yung and Young as:

A(g^u, g^v) = g^{uv}						(12)

This means that the oracle, given the output of g^u and g^v, can compute g^{uv}. Now if the input we give to the oracle is y1^a ?? g^b and Y. Then:

A(y1^a ?? g^b, Y) = A((g^x1 )^a ?? g^b, g^X)

= A(g^{a ?? x1 + b}, g^X)

= g^{X(a ?? x1 + b)}

= (g^X) ^{a ?? x1 + b}

= Y^{a ?? x1 + b}

Then Yung and Young define f = g^x1 / A(y1^a ?? g^b, Y) = g^x1 / Y^{a ?? x1 + b} = g^{x1} ?? Y^{-a??x1 - b} which is equal to z as we have seen in (2) for t = 0. If t = 1, the result is a little bit different since g^{x1} ?? Y^{-a??x1 - b} = z / g^W = f. But as the attacker knows the value of g and W, this does not represent a problem and the private key x2 can then be recovered as desired. On the other hand, this means that an user who got access to every parameter in the device would still not be able to recompute the private key x2.



Then assume we have an oracle B that can break the discret log SETUP which is denoted as:

B(Y, y1) = (z1, z2).

This means that the oracle outputs z1 ??? g^x1 ?? Y^{-a??x1  - b} (mod p) and z2 ??? (g^{x1-W} ?? Y^{-a??x1  - b}) (mod p).

The objective is to find g^{uv} knowing g^u and g^v. By inserting g^x and g^y in the oracle this way:

B(g^v, g^u) = (g^u ?? (g^v ) ^{-a??u-b}, g^{u-W} ?? (g^v )^{-a??u-b} )

we can take the z1 part of the output and calculate:

f = g^{u} ?? (g^{v} )^{-b} / z1 = g^{u ?? (g^{v} )^{-b} / g^{u} ?? (g^{v} )^{-a ?? u - b} = 1 / (g^{v} )^{-a ?? u}}



and then:

(g^{u ?? v})^{-a} = 1/f 
 g^{u ?? v} = f^{1/a} (mod p).

Since the user has access to all of this parameters, he has a way to compute g^{u ?? v}, i.e. he has solved the Diffie-Hellman problem.





> Assuming H is a pseudorandom function, and that the device design is publicly scrutinizable, the outputs of C and C' are polynomially-indistinguishable.

As previously showed, z is uniformly distributed in Zp from their first claim. H is a pseudorandom function by hypothesis so x2 is uniformly distributed. Therefore the outputs C and C' can't be polynomially distinguished because they are the result of a exponentiation. 



With definitions previously seen we showed that this SETUP on Diffie-Hellman is a strong SETUP as defined in **METTRE SECTION ICI**.

Finally, Yung and Young showed that the attack could be improved. Indeed, the attack may seem still a bit weak for the moment because it takes two exchanges to Eve in order to be able to recover the key of a user. But the bandwidth can be drastically increased. The suggested idea is the following: when two key exchanges have already been performed, instead of removing x3 randomly, we compute it as x3 = H(z) where z = g^{x2 - Wt}Y^{-ax2 -b}. Then the new public key y3 is calculated following the same principle as before, i.e. y3 = g^{x3} (mod p). Subsequently, the operation can be repeated l times so that the attack now has a (l, l+1)-bandwidth where after a chain of l private keys generated based on the previous one, the new private key is once again drawn randomly.  



### ASA

In 2014, Bellare, Paterson, and Rogawa brought the formal study of Algorithm Substitution Attack (ASA) which focuses on symmetric encryption[^fn2]. In this model, the encryption algorithm is replaced by a subverted one which was created by a malicious adversary. In the same line as Yung and Young's work on SETUP mechanism, the ASA is conceived in a way that the victim cannot detect a difference between an legitimate output from a subverted one. 



#### ASA definition

In their article, Bellare, Paterson and Rogawa didn't give a formal definition of ASA so the following definition is taken from the article *Algorithm Substitution Attacks from a Steganographic Perspective*[^fn14] of Sebastian Bernd and Maciej Liskiewicz:

> The goal of an algorithm substitution attack (ASA), also called a subversion attack (SA), is to replace an honest implementation of a cryptographic tool by a subverted one which allows to leak private information while generating output indistinguishable from the honest output

Nevertheless, what they say is that they have deliberately chosen to restrict themselves to attacks on symmetric encryption schemes. They give several reasons: the first is that analyzing the risks of subverting a symmetric cipher is paramount because of its wide use in secure communications. The second is that even if they limit themselves to this case, their scenario corresponds to what would happen if an agency like the NSA  would do against a cryptographic library rather than subverting a whole protocol built on the top of the library. In particular if we come back to Bellare *et al.*, they define the notion of symmetric encryption scheme as:



> A scheme for symmetric encryption is a triple ?? = (K, E, D). The key space K is a finite nonempty set. The encryption algorithm E is a possibly randomized algorithm that maps a four-tuple of strings K, M, A, ?? to a pair of strings (C, ??' ) <- E(K, M, A, ??). The arguments to E represent the key, message (plaintext), associated data and current state. The output consists of the ciphertext C and revised state ??'. 

This definition does not bring any new notion to the definition of symmetric encryption scheme but shows adequately the notations used by the authors. Still, we can remark the argument ?? which brings the idea of stateless and stateful encryption and represents a very important notion as we are going to see later. 



#### Stateless and stateful ASA

To move forward, let's define the notion of stateless and stateful ASA and look at the importance of it for Bellare *et al.*  As explained in **METTRE LIEN**, we can define E and D to be stateless of stateful encryption/decryption algorithms. Then the whole symmetric encryption scheme:

> ?? is stateless if both E and D are stateless. In this case, we drop the second component of the output of both algorithms, so that E now returns just a ciphertext and D just a message. 

as expected. 

In their work, one of the objectives was to show that the decryption process must be stateful to avoid the possibility of mounting an ASA. As we will see later, this necessity has been disapproved since under the condition of reducing the strong undetectability property of the ASA, it is possible to obtain a plausible ASA.



#### Decryptability

> We say that ??~ = (K~, E,\~, D\~)  satisfies the decryptability condition relative to ?? = (K, E, D) if (K\~ ?? K, E\~, D' ) is a correct encryption scheme where D' is defined by D' ((K~, K), C, A, ??) = D(K, C, A, ??). Thus, although algorithm E~ operates on a key (K~, K) different from the key K of the base scheme ??, a party possessing only K can decrypt E~-encrypted plaintexts using the legitimate decryption algorithm D.

This implies that the subverted encryption scheme must be able to take both legitimate and illegitimate keys as input and always give the same result as a normal scheme. In addition, any user who is in possession of K can decrypt the ciphertexts that have been produced by the E~.   



### ASA in ECIES

#### ASA in ECIES encryption scheme

As we've already seen in their article of 2020, Chen, Huang and Yung [^fn3] showed there are possible ASAs on PKE (more precisely on KEMs) and they gave a very high level analysis of it. They noticed that a lot of PKE schemes actually use hybrid encryption: they use a public key cryptosystem to encapsulate the *session key* (KEM) which is then used for encrypting a message with the use of a symmetric encryption cryptosystem (DEM). So the main objective is to show how an attacker can subvert the KEM part in a way he can recover the session key so the DEM part shatters.  



In this section we are going to present some new concepts give by the authors and take all the previously enumerated functions they defined to show how it is possible to transpose to mount an ASA in the ECIES scheme. 



##### Universal decryptability

> Let KEM = (KEM.Setup, KEM.Gen, KEM.Enc, KEM.Dec) be a KEM. We say KEM is universally decryptable if for any n ??? N, pp ???\$ KEM.Setup(1n), for any r ??? ???\$ KEM.Rg(pp) and C := KEM.Cg(r), we have 
>
> KEM.Kd(dk, C) = KEM.Kg(ek, r) 
>
> holds for any (ek, dk) ??? ???\$ KEM.Ek(pp).

The universal decryptability of the KEM ASAs is an important property. It states that the output of KEM.Kd(dk, C) should be equal to the output of KEM.Kg(ek, r) for any pair of keys (ek, dk) that has been legitimately generated. This is normal since we want the key decapsulation KEM.Kd algorithm be able to obtain the session key K previously encapsulated with KEM.Kg by the user. 

This changes from the simple decryptability in the sense the KEM constructions they analyzed produce public-key-independent ciphertexts, in fact, the encapsulation is done thanks to the generation of a randomly drawn number. Later we will see that this property is important for the security of the ASA in ECIES.



##### KEM and ASA models comparison 

Chen *et al.* explained the different modules composing a KEM by extracting three main algorithms: KEM.Gen, KEM.Enc and KEM.Dec. 

Here is what these algorithms look like:

```pseudocode
KEM.Gen(pp):
	(ek, dk) ???$ KEM.Ek(pp)
	((tk, vk) ???$ KEM.Tk(pp))
	pk := (ek, tk)
	sk := (dk, vk)
	Return (pk, sk)

KEM.Enc(pk):
 	r ???$ KEM.Rg(pp)
 	K := KEM.Kg(ek, r)
 	C := KEM.Cg(r)
 	(?? := KEM.Tg(tk, r))
	Return (K, ?? = (C, ??))

KEM.Dec(sk, ?? = (C, ??)):
	K_prim := KEM.Kd(dk, C)
	(??_prim := KEM.Vf(vk, C))
	(If ??_prim = ?? then K := K_prim)
	(Else K := ???)
	Return K
```



- KEM.Gen takes as input the public parameter i.e. elliptic curve domain parameters in the case of ECIES that are used by both users to compute correctly every step of the encryption algorithm. This algorithm uses two subalgorithms:

  - KEM.Ek which generates the pair of encapsulation and decapsulation process keys (ek, dk)
  - KEM.Tk which generates the pair of tag generation and verification process keys (tk, vk). This operation is seen as optional if there is no authenticated encryption asked. 

  Then it outputs the public key pk = (ek, tk) which permits the action of encapsulating and generating the tag and the private key sk = (dk, vk) which permits to verify the tag of the message and then if the tag is correct to decrypt.

  In ECIES, this is done exactly the same way as sk is drawn randomly and then pk is computed as pk = sk*G.

- KEM.Enc which takes as input the public key of the other user and outputs the session key K and ?? = (C, ??) where C is the key ciphertext and ?? is the key tag. As in ECIES, we use authentication encryption which implies the calculation of a tag in order to verify that the message received comes from the person we think. Here again, the algorithm is composed of multiple subalgorithms:

  - KEM.Rg which generates the next random value r.

    This is exactly the action of taking a value r at random for the upcoming computation of C = rG in ECIES.

  - KEM.Kg which generates the key K needed for upcoming generation of the encapsulation and encryption keys.

    Derivation of the symmetric encryption key and MAC key with a KDF. The KDF takes the shared secret S = Px where P = (Px, Py) computed as the multiplication of r and the public key.

  - KEM.Cg which computes C = rG which will allow to the other user to perform the decryption of the message as in normal ECIES.

  - KEM.Tg which computes the ciphertext tag. This computation is done only if the authenticated encryption is required. 

- KEM.Dec uses the private key sk and verifies the tag ??. If the tag is correct then decrypts C to find K. 

  - KEM.Kd takes dk and C so it can generate session key K 

    In ECIES this is when the shared secret is derived from C and the receiver's private key. 

  -  KEM.Vf  uses vk and C to compute the tag ??'. Just like some of the previous steps, this step may be optional.

    Note that like in ECIES, if the tags don't match, the encryption is not processed. For this particular algorithm, K is not output.



Now if we compare it to the subverted version:

```pseudocode
ASA.Gen(pp):
	(psk, ssk) ???$ KEM.Ek(pp)
	Return (psk, ssk)
 
ASA.Rec(pk, ssk, Ci , Ci-1 ): /*i > 1*/
	t := KEM.Kd(ssk, Ci-1)
	ri := H (t)
	Ki := KEM.Kg(ek, ri)
	Return Ki
 
ASA.Enc(pk, psk, ??): /*i-th execution*/
	If ?? = ?? then
 		ri ??? $ KEM.Rg(pp)
	Else
		/*Diff*/ t := KEM.Kg(psk, ??)
		/*Diff*/ ri := Hk?? (t)
		
	Ki := KEM.Kg(ek, ri )
	Ci := KEM.Cg(ri)
 	??i := KEM.Tg(tk, ri )
	/*Diff*/ ?? := ri
	Return (Ki , ??i = (Ci , ??i ))
```

we can see some changes have been made. Let's take each algorithm one after the other:



- ASA.Gen does not change significantly. We see the use of KEM.Ek which is enough to perform the encapsulation mechanism. If the authentication of the message is needed, then ASA.Gen is a clone of KEM.Gen. Note that after their generation, psk and ssk are respectively connected to ASA.Enc and guarded by the attacker.
- ASA.Enc, unlike previously, has two more parameters as input: psk the hard-wired public key of the subverter and ?? which represents the internal state and its initial value is set to ??. ?? allows to recognize if it is the first use of ASA.Enc or not in which case the value of ri is not calculated the same way. How the ciphertext is generate still follows the same legitimate process by running KEM.Cg and KEM.Kg. Furthermore this function shows us with the use of this internal state that this ASA is indeed a stateful ASA.
- ASA.Rec is newly introduced and is used to retrieve the session key. To do so, there must be at least more than one ciphertext. 



##### Algorithm of the attack

Suppose Alice wants to communicate securely with Bob using the ECIES encryption scheme. To do this, let Alice and Bob generate their respective key pairs (sk_a, pk_a) and (sk_b, pk_b) and let m1 be the first message she wants to send to him. Finally let Eve's generated keys be (ssk, psk) with the help of function ASA.Gen. Her private key remains secret since she does not want to let anyone use the ASA mechanism and psk is directly wired to the functions requiring it.

First the KEM is used to encapsulate the session key using the ASA.Enc function. Being the first encapsulation that Alice performs, the initial value of ?? is ?? so r1 is drawn randomly with KEM.Rg. So the procedure followed by the algorithm is the following:

first we generate the session key $K_{1}$ using the public key and the random value

K1 = pk_b ?? r1

then we generate C1, the value sent to the other user for the shared secret computation

C1 = r1 ?? G						(1)

and then

??1 = pk_b ?? r1.

Finally ?? takes the value of r1, changing it from initial value ??.

Then comes the DEM part where the data will be effectively encrypted. It does not matter which symmetric encryption algorithm is used since the attack subverts the KEM. Let's say it's AES with mode CTR for the encryption and a HMAC like SHA256 for the authentication. Alice uses K1 to encrypt the message m1 so she gets c1 and calculates the corresponding tag t1.



Let's imagine now that Alice wants to send an other message to Bob. For her, nothing has changed and the KEM once again produces a new session key and a tag generation key, but behind the scenes it is quite different. As we have seen, tau has changed its value so that we will not generate r2 as before. Instead:

t = psk ?? ??							(2)

r2 = H(t)

and then goes as before:

K2 = pk_b ?? r2

C2 = r2 ?? G

??2 = pk_b ?? r2

And now again Alice can encrypt and generate the corresponding tag to send it to Bob. 



##### Recovering the private key

Recall that Eve's pair of key is (ssk, psk). Eve has access only to what Alice sends to Bob, that is to say to the Ci values which allow Bob to carry out the calculation of the shared secret, the public key of Bob pk_b and of course his own generated keys. Elle recovers the session key by doing so:

At the end of the first iteration of ASA.Enc, we saw that tau took the value of the random r1. This means during the second iteration when t has been computed, if we take the relation (2) and change it:

t = psk ?? r1

and we combine with the result (1), then it follows:

t = psk ?? r1 = ssk ?? G ?? r1 = ssk ?? C1  (3)

which is actually the computation realized by ASA.Kd and since Eve has access to all of this information. Therefore, it becomes trivial to find the session key like this:

r2 = H(t)

and then:

K2 = pk_b ?? r2



##### Security of the attack

Because of the somewhat peculiar form of the security proofs provided by Chen *et al* in the form of a game, a reminder of each property obtained as well as an explanation of the proof will be given rather than the more formal proof itself.



As before let KEM = (KEM.Setup, KEM.Gen, KEM.Enc, KEM.Dec) be a KEM and ASA = (ASA.Gen, ASA.Enc, ASA.Rec) be an ASA on KEM, so the results given by the authors are:



>  The ASA preserves the decryptability of KEM.

This property is easily demonstrated. It can be seen that the ASA.Enc function is the same as KEM.Enc except for some details related to the internal generation of the randomness but how the key and the ciphertext are produced remains unchanged. This implies that the property of decryptability still remains. 



> The ASA is session-key-recoverable if KEM is universally decryptable.

 The session-key-recoverability has been described as the ability to correctly recover the session key K output by ASA.Enc with the algorithm ASA.Rec. The result here shows that since the ASA uses KEM.Kd and KEM.Kg and with the definition of universally decryptability, the attacker is able to recover K. This is actually what we have seen in the **METTRE LIEN ICI** recovering the session key section with result (3). 



The authors explain that it is impossible to expect strong undetectability in the sense of Bellare et al. This property ensures that even if the user were to seize key K, he would still not be able to distinguish a legitimate ciphertext from an illegitimate one. Nevertheless, they point out that the condition is easily exploitable and remains very realistic in the sense of a real attack on KEMs because it only requires access to the previous random. 



## Conclusion

In this final chapter, some details of the different presented attacks are repeated to give a brief summary of it. In addition to it, for every attack described, it is mentioned how realistic it is to use it to deploy a kleptographic attack. Followed by this, a few suggestions on how to counter such attacks are given and finally some recommendations on possible research areas that this work could not address.



### Kleptographic attacks

In this thesis, several attacks have been mentioned and explained in detail. In each attack, the user thinks that the device he's using is secure but as we have seen, an attacker could have contaminated the system and, as a result, exfiltrate private key's from the output of the system. 



- SETUP in RSA: the exponent e of the user contains his parameter p. With the use of her private key D, Eve can recover p and then compute q since the parameter n = p ?? q is public. Then Eve can compute ??(n) and then recover Alice's private key d.

  This is a strong SETUP and has a (1,1)-bandwidth leakage.

- SETUP in El Gamal signatures: the random integer k_{i+1} incorporates k\_{i} respectively coming from the second and the first signature.  

  This is a weak SETUP and has a (1,2)-bandwidth leakage.

- SETUP in Diffie-Hellman: this SETUP mechanism integrates the very first user's private key x1 in his second one x2. To perform the recovery, the attacker needs the user to have performed two key exchanges, and thus generated two public keys y1 and y2. For both connections, it is necessary that they involve Alice in the process.

  This is a strong SETUP and has a (1,2)-bandwidth leakage.

- ASA in ECIES: the KEM part of the ECIES hybrid encryption is subverted. The algorithm is modified to hide the session key K in the ciphertext. The random value ri is defined differently depending on whether it is the first iteration of the algorithm or not. Therefore, from the second iteration, the subverter can recalculate the random value used to encapsulate the key and thus find K. 



Of all the attacks presented, the SETUP attack in Diffie-Hellman seems to be the most secure. This is because it is the only one that meets the strong-setup criteria and it uses an operating scheme very close to the original protocol. It is difficult to compare SETUP and ASA because they do not use the same definitions. We can nevertheless note that the attack on ECIES proposed by Bellare seems robust enough to worry about a possible use in cryptosystems, thus implying its possible second place in the usability ranking. We can then quote the attack on the signatures of El Gamal which, despite being a weak-setup, is rather realistic in the sense that the parameters p and g are fixed as is usually the case. Finally comes the attack on RSA but which is based on unrealistic elements such as the fact that e takes too large values, or even that it is normally fixed at 65537.    



### Protections against kleptographic attacks

Throughout this thesis, we have studied how kleptographic attacks were possible on known and widely used cryptosystems through a considerable number of mathematical concepts. However, it is important to note that solutions, although not widely discussed in the literature or by the industry, do exist and are proposed. In this section, we will focus on solutions considered by some researchers to counter such attacks. However, this part does not aim at giving all the details and concepts behind these protections, and even less the audacity to give a perfectly exhaustive list of them.



In the conclusion of their respective articles [^fn2] [^fn3] [^fn5], some of the authors gave countermeasures against the kleptographic attacks:



#### De-randomized algorithms

Giving the user a way to influence the randomness of the system and making the algorithms used accessible. As we have often seen, an important criterion of kleptographic attacks is not to arouse suspicion about the output of the device. Allowing the user to read the algorithm and make sure it works (i.e. not using black-box devices) and the random values it produces would prevent this. If the user then has access to a device that he knows he can trust, he could compare the outputs and make sure they are the same given his total control. 

Like Yung and Young, we can see in the article by Bellare *et al.* that one of the countermeasures that comes up to prevent ASAs is the abandonment of algorithms using randomness and instead using deterministic and stateful algorithms. Yet, as we have seen with ECIES ASA, this condition seems not sufficient since we were able to mount the attack with the effective loss of a security property for the mechanism. Furthermore, Chen *et al.* pointed out that turning your back on non-deterministic algorithms means turning your back on IND-CPA security as well which would be a consequential loss.



#### Cascading cryptosystems

Using cryptosystems of different origins in cascade. As the process is now handled by multiple sources, the chances of a SETUP attack since if one cryptosystem outputs something strange, the other systems may detect it and alert the user. 



#### Integrity checks

The user has to be certain that the software generating the keys is trustworthy. To do so, the user should be able to run integrity checks which can detect modification that could be done to the software. This can be achieved with deterministic compilation[^fn16] (or also known as a reproducible build) and with tools like Gitian[^fn17] or Bazel [^fn18] which ensures that a same source code will product a same binary. If the binary is compiled from trusted source code, then SETUP attacks is countered.  



#### Random generation with a third-party device 

They indicate that in the case of smartcards, an interesting feature would be to allow random number generation using a third-party device. That way, if that other device is trusted, there is no risk that a SETUP attack could be used. 



#### Modular sources

Make the source generating the randomness, the key generation and the user sending messages, separate as three very distinct modules. These three modules must be able to communicate with each other securely, be properly authenticated and not be able to be bypassed in any way. 



#### Industry standards improvement

Industry standards must move in the direction of increasing confidence in hardware devices. This measure proposed by Yung and Young is not very well argued, but it is clear that a somewhat more political dimension is at play here. They do not explain how to increase this confidence, but we can still think   that industry may make some security proofs of their devices, have more open sourced projects and rely more and more on community reviews.



#### Randomized algorithms more constrained

Randomized algorithms may still stay usable with some additional constraints made in a way that it defeats kleptography. 



1. Introduced by Russel, Tang, Yung and Zhou [^fn19], the split-program methodology consists of decomposing the randomized algorithm into two algorithms RG and dG. Later as they showed in a following article[^fn21], this method wasn't sufficient to avoid every type of kleptographic attacks. To address some of the shortcomings of their model, the authors [^fn20] [^fn21] subsequently proposed to decompose their function RG into two independent functions RG0 ad RG1. Their respective outputs are combined (amalgamation of the outputs as the authors call it) with the use of a publicly known hashing function to generate the final random number. This way, one can ensure that the randomness mechanism hasn't been subverted.  
2. Cryptographic reverse firewall introduced by Mironov and Stephens-Davidowitz in [^fn22] has the purpose to protect a protocol between two entities where one of them may use a subverted algorithm. The mechanism is depicted as a third-party whose purpose is to sanitize the user's outgoing transactions so it won't alter its security: it takes the input/output coming from/to the random generation algorithm and re-randomize it. Unfortunately, this implies that the mechanism requires the use of a perfectly reliable source of randomness too.
3. Self-guarding mechanism [^fn23] by Fischlin and Mazaheri is quite interesting and is based on the principle that the subversion of the algorithm will happen sooner or later, but that it first goes through a phase where it can be completely trusted. The idea is to collect samples of cipher from this initial state and store them. In the second phase, when the algorithm has been subverted, the challenge phase begins and the strategy is to use the previous samples to check if the generated ciphers are corrupted in any way.



### Uncovered subjects

This thesis introduced the fundamental concepts of kleptography, presented how it developed over time in parallel with the announcement of various NSA scandals, its renewed interest and the new concepts that are still emerging today. Nevertheless, much of the work done by Yung and Young could not be presented here. We can think in particular of the attack on Kerberos [^fn5], the improvement of the SETUP in RSA using the method of bias removal. Also, it would have been quite possible to implement more ASAs, for example on signature algorithms (put here), or even not to limit it to an encryption scheme but to an application like Signal, or a kleptographic attack implementation against a cryptocurrency. The field of possibilities is, as you can see, enormous.

Finally, even if we have discussed existing countermeasures, it would be interesting to consider, for a future work, showing the effectiveness of these solutions through implementation in Sage and Python as it is the case here. 



### Personal conclusion

Kleptography has been a fascinating field to study, both in terms of the new concepts it has introduced me to and the far-reaching consequences it can have on the real world.
Beyond their work on the subject, and it is perhaps this dimension that resonated with me the most, all these authors were able to highlight a very critical vision of our current society, to push to the reflection on what we use every day and how it is necessary to "consume" the technology that is offered to us. Even if we should not be as alarmist as in Bellare, Rogaway, Paterson's article about mass surveillance, it is certainly good to keep in mind that maliciousness from our governmental institutions is always possible.
By its nature kleptography is elusive and without extensive research on the cryptosystems we use, we can't have warranties of its usage. Because of that, one can easily explain how some people may find conspiracies about global surveillance very credible.

So I would say without falling into the paranoia, this thesis taught me to stay more and more critical of cryptographic algorithms and the importance of reviewing them as much as possible.     



## Annexe



```python
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
    print(f'    N = P ?? Q = {N}')
    print(f'    ??(N) = (P ??? 1)??(Q ??? 1) = {phi}')
    print(f'    E = {E}')
    print(f'    D ??? E^???1 ??? {D} (mod N) \n')
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
    print(f'    n = p ?? q = {n}')
    print(f'    ??(n) = (p ??? 1)??(q ??? 1) = {phi}')
    print(f'    e ??? p^E ??? {p}^{E} ??? {e} (mod N)')
    print(f'    d ??? e^???1 ??? {d} (mod n) \n')
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
    print(f'    p ??? e^D mod(N) ??? {p}')
    q = n/p
    print(f'Knowing p, we can factor n to compute q:')
    print(f'    q = n/p = {q}')
    phi = (p-1)*(q-1)
    print(f'    ??(n) = (p ??? 1)??(q ??? 1) = {phi}')
    d = inverse_mod(e, phi)
    print(f'    d ??? e^???1 ??? {d} (mod n) \n')
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
```



```python
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
    print(f'    r1 ??? g^k1 = {g}^{k} ??? {r} (mod {p})')
    s = (inverse_mod(k, p-1) * (m - x * r)) % (p-1)
    print(f'    s1 ??? k1^???1(m1 ??? x ?? r1 ) ??? {inverse_mod(k, p-1)}({m} - {x}??{r}) ??? {s} (mod {p-1})')
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
    print(f'c ??? Y^k1 ??? {Y}^{k} ??? {c} (mod {p})')

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

    print(f'    k2 ??? c^-1 ??? {k_next} (mod {p-1})')

    r_next = power_mod(g, k_next, p)
    print(f'    r2 ??? g^k2 = {g}^{k_next} ??? {r_next} (mod {p})')
    s_next = (inverse_mod(int(k_next), p-1) * (m - x * r_next)) % (p-1)
    print(f'    s2 ??? k2^???1(m2 ??? x ?? r2 ) ??? {inverse_mod(k_next, p-1)}({m} - {x}??{r_next}) ??? {s_next} (mod {p-1})\n')
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
    print(f'    g^m ??? {sig} (mod {p})')
    sig_prime = (power_mod(y, r, p) * power_mod(r, s, p)) % p
    print(f'    y^r ?? r^s ??? {sig_prime} (mod {p})')
    
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
        print(f'    She computes c ??? ri^X (mod {p}) ??? {r}^{X} (mod {p} ??? {c} (mod {p}))')
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
    print(f'    Y ??? g^X = {g}^{X} ??? {Y} (mod {p})\n')

    print(f'######## VICTIM  ########')
    print(f'Alice generates her keys using g = {g} and p = {p} as parameters')
    (x, y) = elgamal_key_gen(g, p)
    print(f'    x = {x} (This is what we are looking for)')
    print(f'    y ??? g^x = {g}^{x} ??? {y} (mod {p})\n')


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
```





```python
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
    print(f'    r ??? y1_a^a ??g^b = {r} (mod {p})')

    z1 = (y1 * inverse_mod( power_mod(r, X, p), p)) %p
    print(f'    z ??? y1_a^a ??g^b = {r} (mod {p})')

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
    print(f'    Y ??? g^X = {g}^{X} ??? {Y} (mod {p})\n')

    print(f'######## VICTIM  ########')
    print(f'- First signature: Alice want to communicate with Bob -')
    print(f'Alice generates her keys using g = {g} and p = {p} as parameters')
    x1_a, y1_a = gen_first_keypair(p, g)
    print(f'    x1_a = {x1_a} (What we are looking for)')
    print(f'    y1_a ??? g^x1_a = {g}^{x1_a} ??? {y1_a} (mod {p})\n')
    print(f'Alice sends her public key to Bob')

    print(f'Bob generates her keys using g = {g} and p = {p} as parameters')
    x1_b, y1_b = gen_first_keypair(p, g)
    print(f'    x1_b = {x1_b}')
    print(f'    y1_b ??? g^x1_b = {g}^{x1_b} ??? {y1_b} (mod {p})\n')
    print(f'Bob sends his public key to Alice')

    print(f'Alice and Bob can now both compute the shared secret')
    print(f'    Alice by computing: s1 ??? y1_b^x1_a = {gen_shared_secret(x1_a, y1_b, p)}')
    print(f'    Bob by computing: s1 ??? y1_a^x1_b = {gen_shared_secret(x1_b, y1_a, p)}\n')


    print(f'- Second signature: Alice want to communicate with Carol -')
    print(f'Alice generates her keys using g = {g} and p = {p} as parameters')
    x2_a, y2_a = gen_second_keypair(p, g, Y, W, a, b, x1_a)
    print(f'    x2_a = {x2_a} (THIS IS WHAT WE WANT)')
    print(f'    y2_a ??? g^x2_a = {g}^{x2_a} ??? {y2_a} (mod {p})\n')
    print(f'Alice sends her public key to Carol')

    print(f'Carol generates her keys using g = {g} and p = {p} as parameters')
    x1_c, y1_c = gen_first_keypair(p, g)
    print(f'    x1_c = {x1_c}')
    print(f'    y1_c ??? g^x1_c = {g}^{x1_c} ??? {y1_c} (mod {p})\n')
    print(f'Carol sends her public key to Alice')

    print(f'Alice and Carol can now both compute the shared secret')
    print(f'    Alice by computing: s2 ??? y1_c^x2_a = {gen_shared_secret(x2_a, y1_c, p)}')
    print(f'    Carol by computing: s2 ??? y2_a^x1_c = {gen_shared_secret(x1_c, y2_a, p)}')

    print(f'######## SETUP ATTACK ########')

    key = key_recovery(p, g, y1_a, y2_a, a, b, W, X)
    print(f'    Eve has obtained Alice\'s private key: {key == x2_a}')
    print(f'    She can now use Carole\'s public key to compute the shared secret: s2 ??? y1_c^x2_a = {gen_shared_secret(x2_a, y1_c, p)}')

if __name__ == "__main__":
    main()
```



```python
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
		print(f'	t is computed as dk??tau: {t}')
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

#Use AES GCM SIV ?? la place de CTR
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
print(f'	psk = ssk ?? G = {psk}\n\n')

print(f'######## VICTIM ########')
(sk_a, pk_a) = ecies_key_gen()
print(f'Alice generates her keys')
print(f'	sk_a = {sk_a}')
print(f'	pk_a = sk_a ?? G = {pk_a}\n')

(sk_b, pk_b) = ecies_key_gen()
print(f'Bob generates his keys')
print(f'	sk_b = {sk_b}')
print(f'	pk_b = sk_b ?? G = {pk_b}\n\n')


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
```





[^fn1]: http://rump2007.cr.yp.to/15-shumow.pdf
[^fn2]: Security of Symmetric Encryption
[^fn3]: Subvert KEM to Break DEM:Practical Algorithm-Substitution Attacks on Public-Key Encryption
[^fn4]:  Kleptography: Using Cryptography Against Cryptography
[^fn5]:The Dark Side of ???Black-Box?????? Cryptography or: Should We Trust Capstone?
[^fn6]: Problems from the Discrete to the Continuous. Probability, Number Theory, Graph Theory, and Combinatorics

[^fn7]: https://en.wikipedia.org/wiki/Quadratic_residuosity_problem
[^ fn8]: https://www.usenix.org/system/files/conference/usenixsecurity14/sec14-paper-checkoway.pdf
[^fn9]: https://www.reuters.com/article/us-usa-security-rsa-idUSBRE9BJ1C220131220
[^fn10]: https://datatracker.ietf.org/doc/html/draft-rescorla-tls-extended-random-02
[^fn11]: A More Cautious Approach to Security Against Mass Surveillance
[^fn12]:Mass-surveillance without the State: Strongly Undetectable Algorithm-Substitution Attacks
[^fn13]: https://groups.csail.mit.edu/mac/classes/6.805/articles/clipper/short-pieces/wsj-clipper-friend.txt
[^fn14]: Algorithm Substitution Attacks from a Steganographic Perspective

[^fn15]: Stateful Public-Key Cryptosystems: How to Encrypt with One 160-bit Exponentiation

[^fn16]: https://reproducible-builds.org/
[^fn17]:https://gitian.org/
[^fn18]: https://bazel.build/
[^fn19]:Cliptography: Clipping the Power of Kleptographic Attacks
[^fn20]: Generic semantic security against a kleptographic adversary.
[^fn21]: Destroying steganography via amalgamation: Kleptographically cpa secure public key encryption
[^fn22]: Cryptographic reverse firewalls
[^fn23]: Self-guarding cryptographic protocols against algorithm substitution attacks

[^fn24]: Elementary number theory
[^fn25]: https://en.wikipedia.org/wiki/Computational_Diffie%E2%80%93Hellman_assumption
[^fn26]: https://mathworld.wolfram.com/GroupGenerators.html



[]: https://en.wikipedia.org/wiki/Coprime_integers#Probabilities

[]: https://connect.ed-diamond.com/MISC/MISC-084/Surveillance-generalisee-DualECDRBG-10-ans-apres

[]: https://en.wikipedia.org/wiki/Dual_EC_DRBG#cite_note-wired-schneier-4