<!-- index.cfm -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My ColdFusion Chat Page</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            height: 100vh;
            margin: 0;
        }
        main {
            flex-grow: 1;
            overflow-y: auto;
            padding: 20px;
            background-color: #f0f0f0;
        }
        footer {
            padding: 10px;
            background-color: #ccc;
            display: flex;
            align-items: center;
        }
        input[type="text"] {
            flex-grow: 1;
            padding: 10px;
            margin-right: 10px;
            font-size: 16px;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
        }
    </style>

    <script>
        function sendMessage() {
            var message = document.getElementById("messageInput").value;
            
            if (!message.trim()) {
                return alert("Empty message")
            }

            fetch('http://94.247.135.81:8500/rest/api/messages/send', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({ content: message })
            })
            .then(data => {
                document.getElementById("messageInput").value = "";
            });
        }

        function getMessageHtml(message) {
            const date = new Date(message.createdAt).toLocaleString()

            const messageElement = document.createElement("div")
            messageElement.style.padding = "10px"
            messageElement.style.marginBottom = "10px"
            messageElement.style.borderBottom = "1px solid #ccc"
            messageElement.id = message.id
                    
            messageElement.innerHTML = `
                <p><strong style="color: #007BFF;">${message.user.username}</strong> 
                <span style="color: #555; font-size: 13px;">${date}</span></p>
                <p style="margin: 5px 0;">${message.content}</p>
            `;

            return messageElement
        }

        function displayAllMessages() {
            fetch('http://94.247.135.81:8500/rest/api/messages?limit=999999', {
                method: 'GET'
            })
            .then(data => data.json())
            .then(messages => {
                const messagesList = document.getElementById("messagesList");
                messagesList.innerHTML = ""; 

                for (let i = messages.length - 1; i >= 0; i--) { 
                    const message = messages[i];                   
                    
                    messagesList.appendChild(getMessageHtml(message));
                }

                scrollToMessagesListBottom()
            })
        }

        displayAllMessages()

        function scrollToMessagesListBottom() {
            document.getElementById("messagesList").scrollTo({
                    top: messagesList.scrollHeight,
                    behavior: 'smooth'
            });
        }

        let socket = new WebSocket("ws://94.247.135.81:8585/cfusion/websocket/chatChannel");

        socket.onmessage = function(event) {
            const messagesList = document.getElementById("messagesList");
            const messageData = JSON.parse(event.data);
            console.log(messageData)

            let existingMessage = document.getElementById(messageData.id);

            if (existingMessage) {
                existingMessage.querySelector('p:last-child').textContent = messageData.content;
            } else {
                messagesList.appendChild(getMessageHtml(messageData));
            }
            scrollToMessagesListBottom()
        }

        socket.onopen = () => console.log("Connection established");
    </script>
</head>
<body>
    <main id="messagesList">
        <p>Loading...</p>
    </main>
    <footer>
        <input type="text" id="messageInput" placeholder="Type your message..." required>
        <button id="sendButton" onClick="sendMessage()">Send</button>
    </footer>
</body>
</html>
