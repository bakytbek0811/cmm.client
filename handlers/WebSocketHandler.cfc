<cfcomponent output="false">
    
    <cffunction name="onWSOpen">
        <cfargument name="wsEvent" type="struct">
        <!-- Сохраняем сессию клиента -->
        <cfset APPLICATION.connectedClients[wsEvent.wsSession] = wsEvent.wsSession>
    </cffunction>

    <cffunction name="onWSClose">
        <cfargument name="wsEvent" type="struct">
        <!-- Удаляем сессию клиента при отключении -->
        <cfset structDelete(APPLICATION.connectedClients, wsEvent.wsSession)>
    </cffunction>

    <cffunction name="onWSMessage">
        <cfargument name="wsEvent" type="struct">
        <!-- Логируем сообщение -->
        <cfset writeLog(file="websocket", text="Received message: " & wsEvent.data)>
        
        <!-- Отправляем сообщение всем подключенным клиентам -->
        <cfloop collection="#APPLICATION.connectedClients#" item="session">
            <!-- Отправляем сообщение текущей сессии -->
            <cfset wsSendMessage(APPLICATION.connectedClients[session], wsEvent.data)>
        </cfloop>
    </cffunction>

</cfcomponent>
