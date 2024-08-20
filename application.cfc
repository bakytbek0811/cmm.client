<cfcomponent output="false">
    <cfset this.name = "YourAppName">
    <cfset this.applicationTimeout = CreateTimeSpan(1, 0, 0, 0)>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0)>
    <cfset this.setClientCookies = true>
    <cfset this.scriptProtect = "all">
    <cfset this.loginStorage = "session">
    <cfset this.setDomainCookies = false>

    <cfset SetTimeZone("UTC")>

    <cflog  text="Application started" file="application">

    <cffunction  name="onApplicationStart" returntype="boolean" output="false">
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