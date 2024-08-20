<cfcomponent output="false">
    <cffunction  name="sendMessageToQueueForPolicyCheck" access="public" returnType="void">
        <cfargument name="message" required="true" type="any">
        
<!---         <cfset channel = new services.rabbitMqService().getChannel()> --->

        <cfscript>
            queueName = "chat-message-policy-filter-queue";

            isoDate = DateTimeFormat(message.created_at, "yyyy-MM-dd'T'HH:mm:ss'Z'");

            byteArray = serializeJSON({
                "id" = message.id,
                "content" = message.content,
                "originalContent" = message.original_content,
                "fromUserId" = message.from_user_id,
                "createdAt" = isoDate
            }).getBytes("UTF-8");

            application.rabbitChannel.basicPublish("", queueName, JavaCast("null", 0), byteArray);
        </cfscript>
    </cffunction>
</cfcomponent>