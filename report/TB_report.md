





## State of the art

In 1996, Moti Yung and Adam Young worked on the notion of  Secretly Embedded Trapdoor with Universal Protection (SETUP). Their article has refined the existing concepts of SETUP and provided new definitions of them. In addition, they proved that there are attacks that can leak the secret key of a blackbox system without the use of subliminal channels. With this paper and the proofs they made, Yung and Young introduced the concept of kleptography. 

As we will see further, what Yung and Young have showed is that kleptographic attacks can be considered as asymmetric backdoors. An attacker who implements the backdoor into a cryptosystem or cryptographic protocol is the only one who actually can have use of it. Furthermore, they showed that the output of that subverted cryptosystem is what they call *computationally indistinguishable* compared to a legit output. The asymmetric aspect also implies that even if anyone succeeds into reverse-engineering the subverted system, he can find that it's compromised but will not be able to use it, where a classic symmetric backdoor can be in turn used after its discovery.  

//TODO: personne ne prenait ça très au sérieux, trop théorique