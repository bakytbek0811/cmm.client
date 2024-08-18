<cfcomponent output="false">
    <cffunction name="getData" returnType="any" access="public">
        <cfargument name="key" required="true" type="string">

        <cfscript>
            redis = getRedis();

            data = redis.get(arguments.key);

            redis.close();

            return data;
        </cfscript>
    </cffunction>

    <cffunction  name="setData" returnType="void" access="public">
        <cfargument name="key" required="true" type="string">
        <cfargument name="value" required="true" type="string">

        <cfscript>
            redis = getRedis();

            redis.set(arguments.key, arguments.value);

            redis.close();
        </cfscript>
    </cffunction>

    <cffunction name="getRedis" returnType="any" access="public">
        <cfscript>
            jedis = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);

            return jedis;
        </cfscript>
    </cffunction>
</cfcomponent>