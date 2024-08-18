<cfcomponent rest="true" restPath="/messages" output="false">
    <cffunction httpMethod="GET" name="getMessages" restPath="/" access="remote" returnType="any" produces="application/json">
        <cfargument name="page" type="numeric" required="false" restArgSource="query" default="1">
        <cfargument name="size" type="numeric" required="false" restArgSource="query" default="50">

        <cfset SetTimeZone("UTC")>

        <cfset messageService = new services.messageService()>
        
        <cfreturn messageService.getMessagesWithUser(arguments.page, arguments.size)>
    </cffunction>

    <cffunction httpMethod="POST" name="sendMessage" restPath="/send" access="remote" returnType="any" produces="application/json">
        <cfset httpRequestData = getHTTPRequestData()>
        <cfset data = deserializeJSON(httpRequestData.content)>

        <cfset SetTimeZone("UTC")>

        <cfif NOT structKeyExists(data, "content")>
            <cfthrow message="Missing required parameter: content" type="InvalidRequestException">
        </cfif>

        <cfset authService = new services.authService()>

        <cfset fromUserId = authService.getUserIdFromToken()>

        <cfset messageService = new services.messageService()>
        <cfset message = messageService.saveMessage(data.content, fromUserId)>

        <cfset new services.policyFilterService().sendMessageToQueueForPolicyCheck(message)>

        <cfset wsPublish("chatChannel", message)/>
    </cffunction>
</cfcomponent>
