<cfcomponent output="false">
    <cfset this.name = "ChatApp">

    <cfset SetTimeZone("UTC")>

    <cfset this.mappings["/lib"] = "/opt/cmm.client/lib">

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>   
        
        <cfscript>
            application.redisConnection = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);
        </cfscript>

        <cfscript>
            rabbitFactory = createObject("java", "com.rabbitmq.client.ConnectionFactory");
            connectionFactory = rabbitFactory.init();
            connectionFactory.setHost("94.247.135.81");
            connectionFactory.setUsername("guest");
            connectionFactory.setPassword("guest");

            application.rabbitConnection = connectionFactory.newConnection();
            application.rabbitChannel = application.rabbitConnection.createChannel();
        </cfscript>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>