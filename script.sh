#!/bin/bash

# Path to your wordlist
wordlist="/root/Desktop/wordlists/shares.txt"
target="target.ine.local"

# Loop through each share in the wordlist
while read -r share; do
  echo "Attempting anonymous login to share: $share"

  # Try to connect anonymously
  smbclient "\\\\$target\\$share" -U ""%"" -N

  if [ $? -eq 0 ]; then
    echo "[+] Anonymous access successful for share: $share"
  else
    echo "[-] Failed to access share: $share"
  fi
done < "$wordlist"
