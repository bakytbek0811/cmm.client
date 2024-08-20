<cfcomponent output="false">
    <cfset this.name = "ChatApp">

    <cfset SetTimeZone("UTC")>

    <cflog  text="Application started" file="application">

    <cffunction  name="onApplicationStart" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>  

        <cflog  text="onApplicationStart" file="application">
        
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