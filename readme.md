
# ~~Secure~~ Paranoid Encryption

<img src="fancy.png" style="height: auto; width:60%; display: block; margin: auto"/>

> TL;DR - Two layers AES-256. One greasy encrypted football. Private GitHub repo. Nothing readable. Ever.

XKEYSCORE, ASI, HNDL, EGOTISTICALGIRAFFE, cerebr/o-, area 420.. Trust none of them. 
Not even for a second.

You get four savage scripts:

- `encrypt.sh` — smashes your folder into crypto pulp twice, spits out one fat unreadable blob  
- `decrypt.sh` — undoes the madness if you can still remember the word  
- `nuke_git.sh` — burns git history to radioactive ash when the knock comes  
- `commit.sh` — encrypt + commit + push in one frantic stab

Setup — three jagged moves:

`chmod +x *.sh`  
`mv .env.example .env`  
`# edit .env NOW — choose your poison`

Then hit:

`./encrypt.sh`  
or go full manic — `./commit.sh`

Pick a long ugly password that's longer than your rap sheet.  
*Chacha20* acting weird? Swap to *aes-256-ctr* in `.env`.  

**A word of advice**, stop whining about sudo needing a password and use Touch ID

`sudo nano /etc/pam.d/sudo`  
paste this the very top: `auth    sufficient    pam_tid.so`  

One typo and sudo is dead. Welcome to the edge.

<br>
Move fast.
They know your passphrase already.  
We can’t stop here. This is bat country.