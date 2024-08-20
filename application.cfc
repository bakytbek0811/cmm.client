<cfcomponent output="false">
    <cfset this.name = "ChatApp">

    <cfset SetTimeZone("UTC")>

    <cffunction  name="onApplicationStart" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>  
        
        <cfscript>
            rabbitFactory = createObject("java", "com.rabbitmq.client.ConnectionFactory");
            connectionFactory = rabbitFactory.init();
            connectionFactory.setHost("94.247.135.81");
            connectionFactory.setUsername("guest");
            connectionFactory.setPassword("guest");

            connection = connectionFactory.newConnection();
            channel = connection.createChannel();

            application.rabbitChannel = channel;
            application.myGlobalVariable = "Some value";
        </cfscript>

        <cfreturn true>
    </cffunction>
</cfcomponent>