<cfcomponent output="false">
    <cffunction  name="getChannel" returnType="any" access="public">        
        <cfscript>
            rabbitFactory = createObject("java", "com.rabbitmq.client.ConnectionFactory");
            connectionFactory = rabbitFactory.init();
            connectionFactory.setHost("94.247.135.81");
            connectionFactory.setUsername("guest");
            connectionFactory.setPassword("guest");

            connection = connectionFactory.newConnection();
            channel = connection.createChannel();

            return channel;
        </cfscript>
    </cffunction>
</cfcomponent>