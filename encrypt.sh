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

# Secure password prompt
read -s -r -p "Enter encryption password: " PASSWORD
echo
if [ -z "$PASSWORD" ]; then
  echo "Error: Password cannot be empty"
  exit 1
fi

echo "Zipping ${TARGET_FOLDER} → ${TEMP_ZIP} ..."
(
  cd "${TARGET_FOLDER}" || exit 1
  zip -r "../${TEMP_ZIP}" . -x '*/.DS_Store' '*/Thumbs.db' || exit 1
)

echo "Encrypting layer 1 (${CIPHER1}) ..."
openssl enc -"${CIPHER1}" -pbkdf2 -iter "${PBKDF2_ITER}" -salt \
  -in "${TEMP_ZIP}" -out "${TEMP_LAYER1}" -pass pass:"${PASSWORD}" || exit 1

echo "Encrypting layer 2 (${CIPHER2}) ..."
openssl enc -"${CIPHER2}" -pbkdf2 -iter "${PBKDF2_ITER}" -salt \
  -in "${TEMP_LAYER1}" -out "${ENCRYPTED_FILE}" -pass pass:"${PASSWORD}" || exit 1


# Unset sensitive data
unset PASSWORD

# Clean up
rm -f "${TEMP_ZIP}" "${TEMP_LAYER1}"

echo "Done. Encrypted file created: ${ENCRYPTED_FILE}"