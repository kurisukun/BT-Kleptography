## Introduction





## Specifications



### Problematic



### Goals:

- Study 



## State of the art

In 1996, Moti Yung and Adam Young worked on the notion of  Secretly Embedded Trapdoor with Universal Protection (SETUP). They wanted to show the threats one can encounter when using a blackbox device such as smartcards and more recently mobile phones. Their article has refined the existing concepts of SETUP and provided new definitions of them. In addition, they proved that there are attacks that can leak the secret key of a blackbox system without the use of subliminal channels. With this paper and the proofs they made, Yung and Young introduced the concept of kleptography. 

As we will see further, what Yung and Young have showed is that kleptographic attacks can be considered as asymmetric backdoors. An attacker who implements the backdoor into a cryptosystem or cryptographic protocol is the only one who actually can have use of it. Furthermore, they showed that the output of that subverted cryptosystem is what they call *computationally indistinguishable* compared to a faithful output. The asymmetric aspect also implies that even if anyone succeeds into reverse-engineering the subverted system, he can find that it's compromised but will not be able to use it, where a classic symmetce ric backdoor can be in turn used after its discovery.

The implications of their results were great but at the time only a very few of academics believed in them. it was considered more of a theoretical issue than a real threat. This was until 2013 with the Dual_EC_DRBG controversy. 

The pseudorandom number generator was initially published in 2006 by the NIST and was intended to have a security proof. Since then a lot of researchers highlighted the multiple flaws present in the algorithm architecture and two cryptologists of Microsoft, Dan Shumow and Niels Ferguson, warned of the possible existence of a backdoor [^fn1]. In spite of this Dual_EC_DRBG has been standardized and implemented in multiple libraries like RSA BSAFE or OpenSSL. All suspicions will be proven true when finally several internal NSA documents will be leaked following the Snowden affair and will indicate the existence of the SIGINT project, thus proving the existence of the famous backdoor in the Dual_EC_DRBG algorithm and the very important role that the intelligence agency played in the standardization process. 

From 2014 onwards, the game has changed and many cryptologists are now looking into kleptography and various attacks and concepts are emerging. Moreover, there is finally a real interest in how to protect against kleptographic attacks[^fn2] and this even for cryptographic systems based on post-quantum and quantum algorithms[^fn3].









[^fn1]: http://rump2007.cr.yp.to/15-shumow.pdf
[^fn2]: Security of Symmetric Encryption
[^fn3]: Subvert KEM to Break DEM:Practical Algorithm-Substitution Attacks on Public-Key Encryption