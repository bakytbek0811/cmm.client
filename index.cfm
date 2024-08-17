<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ChatPage</title>
    <style>
        * {
            box-sizing: border-box;
        }

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
            width: 100%;
        }
        input[type="text"] {
            width: 100%;
            flex-grow: 1;
            padding: 10px;
            margin-right: 10px;
            font-size: 16px;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
        }
        #authModal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }
        #authModal input[type="text"] {
            margin-bottom: 10px;
            width: 100%;
            padding: 10px;
            font-size: 16px;
        }

        .authenticated {
            display: none;
        }
    </style>

    <script>
         function showAuthenticatedContent() {
            const elements = document.querySelectorAll('.authenticated');
            elements.forEach(element => {
                element.style.display = 'block';
            });
        }

        function login() {
            var username = document.getElementById("usernameInput").value;
            
            if (!username.trim()) {
                return alert("Please enter a username");
            }

            fetch('http://94.247.135.81:8500/rest/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({ username: username })
            })
            .then(response => response.text())
            .then(data => {
                document.getElementById("authModal").style.display = "none";
                window.location.reload();
            });
        }

        function checkAuth() {
            fetch('http://94.247.135.81:8500/rest/api/auth/check-auth', {
                method: 'GET'
            })
            .then(response => response.text())
            .then(data => {
                if (data === "false") {
                    document.getElementById("authModal").style.display = "block";
                } else {
                    displayAllMessages();
                    showAuthenticatedContent();
                    startLoadingMessagesWithInterval();
                }
            });
        }

        function sendMessage() {
            var message = document.getElementById("messageInput").value;
            
            if (!message.trim()) {
                return alert("Empty message");
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

                displayAllMessages();
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

            return messageElement;
        }

        function displayAllMessages(isFirstLoad = true) {
            fetch('http://94.247.135.81:8500/rest/api/messages?limit=999999', {
                method: 'GET'
            })
            .then(response => response.json())
            .then(messages => {
                const messagesList = document.getElementById("messagesList");
                messagesList.innerHTML = ""; 

                for (let i = messages.length - 1; i >= 0; i--) { 
                    const message = messages[i];                   
                    
                    messagesList.appendChild(getMessageHtml(message));
                }

                if (isFirstLoad) {
                    scrollToMessagesListBottom();
                }
            });
        }

        function scrollToMessagesListBottom() {
            document.getElementById("messagesList").scrollTo({
                    top: messagesList.scrollHeight,
                    behavior: 'smooth'
            });
        }

        function startLoadingMessagesWithInterval() {
            setInterval(() => displayAllMessages(false), 2500)
        }

        checkAuth();
    </script>
</head>
<body>
    <main id="messagesList" class="authenticated">
        <p>Loading...</p>
    </main>
    <div class="authenticated"> 
        <footer style="width: 100%">
            <input type="text" id="messageInput" placeholder="Type your message..." required>
            <button id="sendButton" onClick="sendMessage()">Send</button>
        </footer>
    </div>

    <!-- Модальное окно для авторизации -->
    <div id="authModal">
        <h2>Login</h2>
        <input type="text" id="usernameInput" placeholder="Enter your username" required>
        <button onClick="login()">Login</button>
    </div>
</body>
</html>
