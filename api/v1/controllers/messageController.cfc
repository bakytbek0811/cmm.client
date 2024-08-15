<cfcomponent rest="true" restPath="/messages">
    <cffunction httpMethod="GET" name="getMessages" restPath="/" access="remote" returnType="any" produces="application/json">
        <cfargument name="page" type="numeric" required="false" restArgSource="query" default="1">
        <cfargument name="size" type="numeric" required="false" restArgSource="query" default="50">

        <cfset SetTimeZone("UTC")>

        <cfset var offset = ((arguments.page - 1) * arguments.size)>

        <cfquery name="messages" datasource="chatMainDb">
            SELECT 
                m.id, 
                m.content, 
                m.from_user_id, 
                m.created_at, 
                u.username as username
            FROM 
                messages m
            INNER JOIN 
                users u 
            ON 
                m.from_user_id = u.id
            ORDER BY 
                m.created_at DESC
            LIMIT 
                <cfqueryparam value="#arguments.size#" cfsqltype="cf_sql_integer">
            OFFSET 
                <cfqueryparam value="#offset#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfset result = []>

        <cfloop query="messages">
            <cfset messageData = {
                "id" = messages.id,
                "content" = messages.content,
                "createdAt" = messages.created_at,
                "user" = {
                    "id" = messages.from_user_id,
                    "username" = messages.username
                }
            }>

            <cfset arrayAppend(result, messageData)>
        </cfloop>

        <cfreturn result>
    </cffunction>

    <cffunction httpMethod="POST" name="sendMessage" restPath="/send" access="remote" returnType="any" produces="application/json">
        <cfset httpRequestData = getHTTPRequestData()>
        <cfset data = deserializeJSON(httpRequestData.content)>

        <cfset SetTimeZone("UTC")>

        <cfif NOT structKeyExists(data, "content")>
            <cfheader statusCode="404" statusText="Bad request.">
            <cfthrow message="Missing required parameter: content" type="InvalidRequestException">
        </cfif>

        <cfset jwt = new lib.jwt.models.jwt()>
        <cfset headers = getHTTPRequestData().headers>

        <cfscript>
            jedis = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);

            fromUserId = jedis.get("cmm:accessToken:" & token);

            if (!fromUserId) {
                return {
                    status: 401,
                    message: "Unauthorized."
                };
            }
        </cfscript>

        <cfquery name="message" dataSource="chatMainDb">
            INSERT INTO messages (content, original_content, from_user_id, created_at)
            VALUES (
                <cfqueryparam value="#data.content#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#data.content#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#fromUserId#" cfsqltype="cf_sql_integer">,
                now()
            )
            RETURNING *
        </cfquery>

        <cfscript>
            try {
                rabbitFactory = createObject("java", "com.rabbitmq.client.ConnectionFactory");
                connectionFactory = rabbitFactory.init();
                connectionFactory.setHost("94.247.135.81");
                connectionFactory.setUsername("guest");
                connectionFactory.setPassword("guest");

                connection = connectionFactory.newConnection();
                channel = connection.createChannel();
                queueName = "chat-message-policy-filter-queue";

                isoDate = DateTimeFormat(message.created_at, "yyyy-MM-dd'T'HH:mm:ss'Z'");

                byteArray = serializeJSON({
                    "id" = message.id,
                    "content" = message.content,
                    "originalContent" = message.original_content,
                    "fromUserId" = message.from_user_id,
                    "createdAt" = isoDate
                }).getBytes("UTF-8");
                
                channel.basicPublish("", queueName, JavaCast("null", 0), byteArray);

                responseMessage = "OK";
            } catch (any e) {
                var errorMessage = "Error: " & e.message;
                if (isDefined("e.stackTrace")) {
                    errorMessage &= "<br>Stack Trace: " & e.stackTrace;
                }

                responseMessage = errorMessage;
            } finally {
                if (isDefined("channel") AND isObject(channel)) {
                    channel.close();
                }
                if (isDefined("connection") AND isObject(connection)) {
                    connection.close();
                }
            }
        </cfscript>

        <cfset messageData = serializeJSON({
                "id" = message.id,
                "user" = {
                    "id" = message.from_user_id,
                    "username" = "Bakytbek"
                },
                "createdAt" = message.created_at
            })>

        <cfreturn data>
    </cffunction>
</cfcomponent>
