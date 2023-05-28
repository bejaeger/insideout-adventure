#!/usr/bin/env bash

# Sponsor -> Guardian
sed -i '' 's/parental/guardian/g' *.json
sed -i '' 's/parent/guardian/g' *.json # Should be a 'No Operation'. Included for completeness.
sed -i '' 's/Parent/Guardian/g' *.json # Should be a 'No Operation'. Included for completeness.
sed -i '' 's/children/wards/g' *.json # Should be a 'No Operation'. Included for completeness.
sed -i '' 's/Children/Wards/g' *.json # Should be a 'No Operation'. Included for completeness.
sed -i '' 's/child/ward/g' *.json # Should be a 'No Operation'. Included for completeness.
sed -i '' 's/Child/Ward/g' *.json # Should be a 'No Operation'. Included for completeness.
sed -i '' 's/explorer/ward/g' *.json
sed -i '' 's/Explorer/Ward/g' *.json
