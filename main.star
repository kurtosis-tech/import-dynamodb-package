NAME = "import-dynamodb"
IMAGE = "bchew/dynamodump"

def run(
    plan,
    db_endpoint,
    aws_access_key_id,
    aws_secret_access_key,
    aws_region
    ):
    """
    Import AWS DynamoDB data into a local DynamoDB 
    """
    exec_recipe = ExecRecipe(
        command = ["dynamodump", "-h"]
    )

    ready_conditions_config = ReadyCondition(
        recipe = exec_recipe,
        field = "code",
        assertion = "==",
        target_value = 0,
        interval = "2s",
        timeout = "10s",
    )

    service_config= ServiceConfig(
        image = IMAGE,
        entrypoint = ["/bin/sh", "-c"],
        cmd = ["sleep 3600"],
        ready_conditions=ready_conditions_config,
    )

    service = plan.add_service(name = NAME, config = service_config)

    exec_recipe = ExecRecipe(
        command = ["dynamodump",
                   "-m",
                   "backup",
                   "--accessKey",
                   aws_access_key_id,
                   "--secretKey",
                   aws_secret_access_key,
                   "-r",
                   aws_region,
                   "-s",
                   "*"],
    )
    result = plan.exec(service_name=NAME, recipe=exec_recipe)
    plan.verify(result["code"], "==", 0)

    host_and_port = db_endpoint.split("/")[2]
    host, port = host_and_port.split(":")
    exec_recipe = ExecRecipe(
        command = ["dynamodump",
                   "-m",
                   "restore",
                   "--accessKey",
                   aws_access_key_id,
                   "--secretKey",
                   aws_secret_access_key,
                   "-r",
                   "local",
                   "--host",
                   host,
                   "--port",
                   port,
                   "-s",
                   "*"],
    )
    result = plan.exec(service_name=NAME, recipe=exec_recipe)
    plan.verify(result["code"], "==", 0)

    return {"service-name": NAME}
