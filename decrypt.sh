#!/bin/bash
unset HISTFILE
set -euo pipefail

# Load shared config
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Error: .env file not found"
  exit 1
fi

# Check input file exists
if [ ! -f "${ENCRYPTED_FILE}" ]; then
  echo "Error: Encrypted file not found: ${ENCRYPTED_FILE}"
  exit 1
fi

# Secure password prompt
read -s -r -p "Enter decryption password: " PASSWORD
echo

if [ -z "$PASSWORD" ]; then
  echo "Error: Password cannot be empty"
  exit 1
fi

echo "Decrypting layer 2 (${CIPHER2}) ..."
openssl enc -d -"${CIPHER2}" -pbkdf2 -iter "${PBKDF2_ITER}" \
  -in "${ENCRYPTED_FILE}" -out "${TEMP_LAYER2}" -pass pass:"${PASSWORD}" || exit 1

echo "Decrypting layer 1 (${CIPHER1}) ..."
openssl enc -d -"${CIPHER1}" -pbkdf2 -iter "${PBKDF2_ITER}" \
  -in "${TEMP_LAYER2}" -out "${TEMP_ZIP}" -pass pass:"${PASSWORD}" || exit 1

echo "Extracting to ${OUTPUT_FOLDER} ..."
mkdir -p "${OUTPUT_FOLDER}"
unzip -o "${TEMP_ZIP}" -d "${OUTPUT_FOLDER}" || exit 1

# Unset sensitive data
unset PASSWORD

# Clean up
rm -f "${TEMP_ZIP}" "${TEMP_LAYER2}"

echo "Done. Decrypted files extracted to: ${OUTPUT_FOLDER}"