#!/usr/bin/env bash

# Sponsor -> Guardian
sed -i '' 's/sponsors/guardians/g' *.json
sed -i '' 's/sponsoring/guardianship/g' *.json
sed -i '' 's/Sponsoring/Guardianship/g' *.json
sed -i '' 's/isSponsored/hasGuardian/g' *.json
sed -i '' 's/sponsor/guardian/g' *.json
sed -i '' 's/Sponsor/Guardian/g' *.json
