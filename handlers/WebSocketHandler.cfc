<cfcomponent output="false">

    <cffunction name="onOpen">
        <cfargument name="wsEvent" type="struct">

        <!-- Создаем уникальный идентификатор клиента -->
        <cfset var clientId = createUUID()>

        <!-- Сохраняем информацию о клиенте в структуре APPLICATION.connectedClients -->
        <cfset APPLICATION.connectedClients[clientId] = {
            clientId = clientId,
            wsSession = wsEvent.session,
            connectedAt = now()
        }>

        <!-- Логируем факт подключения -->
        <cfset writeLog(file="websocket", text="Client connected: " & clientId)>
    </cffunction>

    <cffunction name="onClose">
        <cfargument name="wsEvent" type="struct">

        <!-- Поиск и удаление клиента по сессии -->
        <cfloop collection="#APPLICATION.connectedClients#" item="key">
            <cfif APPLICATION.connectedClients[key].wsSession eq wsEvent.session>
                <cfset structDelete(APPLICATION.connectedClients, key)>
                <cfset writeLog(file="websocket", text="Client disconnected: " & key)>
                <cfbreak>
            </cfif>
        </cfloop>
    </cffunction>

    <cffunction name="onMessage">
        <cfargument name="wsEvent" type="struct">

        <!-- Логирование полученного сообщения -->
        <cfset writeLog(file="websocket", text="Received message: " & wsEvent.data)>

        <!-- Отправка сообщения всем подключенным клиентам на канале chatChannel -->
        <cfloop collection="#APPLICATION.connectedClients#" item="key">
            <cfset wsSendMessage(channel="chatChannel", message=wsEvent.data)>
        </cfloop>
    </cffunction>

</cfcomponent>
