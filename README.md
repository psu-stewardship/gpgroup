gpgroup
=======

gpg and group permissions

Justin Patterson and Scott Woods brainstormed this operation in the hopes of finding a more secure, and perhaps more convenient alternative to chef encrypted data bags and our secure drive.

- Like rbenv, each directory can potentially have a .gpg-recipients file that contains the identifiers of recipients who should be allowed to decrypt the files in that directory and in child directories. Another way of saying the same thing is that a given file should be decrypt-able by the union of recipients listed in .gpg-recipients files of all parent directories.
- The root of the project contains a .gpg-known-keys directory. Each file in that directory is the public key of one of the potential recipients. This directory by itself does not grant any permissions — it just provides the database of potential recipients that are known to the system. This is our mechanism for distributing public keys — it’s essentially our own key server.
- When we’re encrypting a file, the command reads each .gpg-recipients file in each of the parent directories to collect the total set of recipients for that file. The search for parent directories stops when we reach the directory that contains the .gpg-known-keys directory — that’s understood to be the project root. This prevents a .gpg-recipeints file in a user’s home directory or the root of the filesystem from polluting the set of possible recipients.
- We should use thor or sub to create a parent command and subcommands for this.
- We should collaborate on this and make it open source.
- We need one subcommand that allows us to edit any file, and it will handle the decryption, temporary files, and re-encryption according to .gpg-recipients files.
- We need a command to re-encrypt all files below the current directory (in case .gpg-recipient files get edited).
- We should be able to quickly import the public keys of recipients. Still don’t know exactly where to store those.
- Encrypted files should be stored ascii armored, for ease of git management, reading, and distribution. They should still get a .gpg extension though.
- Chef will need a little library method like `Chef::GPG.decrypt` that knows how to decrypt a secret using the machine’s key and return that secret's contents. It should raise an exception if the decryption fails. This library method probably isn’t part of the gpg utility package.
- I’m guessing we want to use gpg1, not gpg2. See this confusing discussion: http://ubuntuforums.org/showthread.php?t=1001120

Example directory structure:

```
  * .gpg-known-keys/

      * root@handbook.westarete.com.gpg
      * root@scholarsphere.psu.edu.gpg
      * scott@westarete.com.gpg
      * jrp22@psu.edu.gpg

   * secrets/

      * .gpg-recipients (lists the devops people, e.g. jrp22@psu.edu, scott@westarete.com, etc.) 
      * github_chef_node_api_key.gpg
      * handbook/

         * .gpg-recipients (lists the handbook servers, e.g. root@www1.handbook.westarete.com, etc.)
         * session_secret.gpg
         * password_pepper.gpg

      * scholarsphere/

         * .gpg-recipeints (lists the scholarsphere servers)
         * session_secret.gpg
         * password_pepper.gpg
         * scholarsphere.psu.edu.key.gpg
```

Here is how we handled non-interactive key generation: https://gist.github.com/woods/8970150 

## Usage

    gpgroup init               # Creates the initial .gpg-known-keys and .gpg-recipients
    gpgroup import [filename]  # Import the public gpg keys under .gpg-known-keys
    gpgroup edit <filename>    # Decrypt (or create) the given file and open it in the default editor
    gpgroup encrypt [path]     # Encrypt or re-encrypt the given filename or path according to recipients
    gpgroup decrypt <filename> # Print decrypted version of file to standard output
    gpgroup status <filename>  # Print out the current status and recipients of the given filename
