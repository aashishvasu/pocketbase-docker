#!/bin/sh
# Custom run script for PocketBase

# Check if the pb_data folder exists
# Check if the pb_data/initialized file does not exist
if [ ! -f "pb_data/initialized" ]; then
    echo "Initial setup required: pb_data/initialized file not found."

	# Create pb_migrations folder if it doesn't exist
	mkdir -p pb_migrations

	# Create admin.js file and populate it with the migration code
	cat > pb_migrations/admin.js <<EOF
migrate((db) => {
	// Create admin user
	const dao = new Dao(db)
	const admin = new Admin()

	admin.email = "${PBADMINUSR}"
	admin.setPassword("${PBADMINPWD}");

	const collection = dao.findCollectionByNameOrId("users")
	const username = "${PBADMINUSR%@*}" // extract the username part before the "@" symbol from PBADMINUSR
	const record = new Record(collection)
	record.setUsername(username)
	record.setEmail("${PBADMINUSR}")
	record.setPassword("${PBADMINPWD}")
	record.setVerified(true)
	record.set("role", "super")

	dao.saveAdmin(admin)
	return dao.saveRecord(record)
}, (db) => {
	// Find and delete admin user on running this migration script again
	const dao = new Dao(db)

	const admin = dao.findAdminByEmail("${PBADMINUSR}")
	const record = dao.findAuthRecordByEmail("users", "${PBADMINUSR}")

	dao.deleteAdmin(admin)
	return dao.deleteRecord(record)

})
EOF
	# Run pocketbase migrate to apply the migration
	./pocketbase migrate
	echo "App super user created and ready to use."
	
	# Clean up the migration script after running
	rm -f pb_migrations/admin.js

	# Mark the initialization as complete by creating the initialized file
    mkdir -p pb_data # Ensure pb_data directory exists
    touch pb_data/initialized
else
	echo "Initialization previously completed. Skipping setup."
fi

# Start PocketBase with desired options
./pocketbase serve --http=0.0.0.0:8080
