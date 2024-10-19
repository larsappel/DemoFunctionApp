#!/bin/bash

mkdir -p web

# Create an index.html file for the JavaScript app using a here document
cat > web/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Form</title>
</head>
<body>
    <h2>Contact Form</h2>
    <form id="contactForm">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>
        <br><br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        <br><br>
        <button type="submit">Submit</button>
    </form>

    <!-- Add a link to registrations.html -->
    <br><br>
    <a href="registrations.html">View Registrations</a>

    <script>
        // Add event listener for form submission
        document.getElementById("contactForm").addEventListener("submit", async function(event) {
            event.preventDefault(); // Prevent default form submission behavior
            
            // Get form data
            const name = document.getElementById("name").value;
            const email = document.getElementById("email").value;

            // Prepare JSON payload
            const payload = {
                name: name,
                email: email
            };

            try {
                // Send the data to the API
                const response = await fetch("https://demofunc$(date +"%y%m%d").azurewebsites.net/api/tabledemo", { // Replace with your API endpoint
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "x-functions-key": "campusmolndal" // Add the function key in the header
                    },
                    body: JSON.stringify(payload)
                });

                // Check if the response is successful
                if (response.ok) {
                    alert("Form submitted successfully!");
                } else {
                    alert("Failed to submit the form.");
                }
            } catch (error) {
                console.error("Error:", error);
                alert("An error occurred while submitting the form.");
            }
        });
    </script>
</body>
</html>
EOF

# Create an index.html file for the JavaScript app using a here document
cat > web/registrations.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Entries</title>
</head>
<body>
    <h2>Contact Form Entries</h2>

    <!-- List to display all entries -->
    <ul id="entriesList">
        <!-- Entries will be dynamically added here -->
    </ul>

    <script>
        // Function to fetch all entries from the API and display them in the list
        async function fetchEntries() {
            try {
                const response = await fetch("https://demofunc$(date +"%y%m%d").azurewebsites.net/api/getallentries", { // Replace with your function key
                    method: "GET",
                    headers: {
                        "x-functions-key": "campusmolndal" // Alternatively, add the function key here
                    }
                });

                // Check if the response is successful
                if (response.ok) {
                    const entries = await response.json();

                    // Get the list element to display the entries
                    const entriesList = document.getElementById("entriesList");

                    // Clear any existing content
                    entriesList.innerHTML = "";

                    // Loop through the entries and create list items
                    entries.forEach(entry => {
                        const listItem = document.createElement("li");
                        listItem.textContent = \`Name: \${entry.name}, Email: \${entry.email}\`;
                        entriesList.appendChild(listItem);
                    });
                } else {
                    alert("Failed to fetch entries.");
                }
            } catch (error) {
                console.error("Error:", error);
                alert("An error occurred while fetching the entries.");
            }
        }

        // Fetch the entries when the page loads
        window.onload = fetchEntries;
    </script>
</body>
</html>
EOF
