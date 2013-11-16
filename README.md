CaesarCipher
=============

The goal of this project is to create a simple "Hello world" type of assembly program, implementing the simplest and least secure cipher. This program will feature basic file IO and random number generation in assembly.

The program is written for Intel-syntax in NASM, for x86_64 Linux.

Encrypt will generate the data offset (the key) in 'keyfile', apply this to the data in 'mmessage', and store the resulting data in 'encrypted'. Decrypt will simply take the key and reverse the offset to produce 'decrypted', which should be identical to 'message'.

