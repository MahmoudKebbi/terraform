```mermaid
graph TD
    root[.] --> readme[README.md]
    root --> dir_structure[directory structure]
    root --> errored[errored.tfstate]
    root --> main_tf[main.tf]
    root --> modules[modules]
    root --> tf_vars[terraform.tfvars]
    root --> vars[variables.tf]
    
    %% Modules
    modules --> chat[chat]
    modules --> energy[energy_trade]
    modules --> iot[iot]
    modules --> ml[ml]
    modules --> user[user_management]
    
    %% Chat module
    chat --> chat_main[main.tf]
    chat --> chat_modules[modules]
    chat --> chat_out[outputs.tf]
    chat --> chat_vars[variables.tf]
    
    chat_modules --> chat_api[api_gateway]
    chat_modules --> chat_dynamo[dynamodb]
    chat_modules --> chat_ecr[ecr]
    chat_modules --> chat_ecs[ecs]
    chat_modules --> chat_iam[iam]
    chat_modules --> chat_vpc[vpc]
    
    %% Energy trade module
    energy --> energy_lambda[lambda_functions]
    energy --> energy_main[main.tf]
    energy --> energy_modules[modules]
    energy --> energy_tfvars[terraform.tfvars]
    energy --> energy_vars[variables.tf]
    
    energy_lambda --> energy_admin[admin]
    energy_lambda --> energy_user[user]
    energy_lambda --> energy_ws[ws]
    
    energy_modules --> energy_api[apigateway]
    energy_modules --> energy_dynamo[dynamodb]
    energy_modules --> energy_iam[iam]
    energy_modules --> energy_lambda_mod[lambda]
    
    %% IoT module
    iot --> iot_main[main.tf]
    iot --> iot_modules[modules]
    iot --> iot_ca_key[myCA.key]
    iot --> iot_ca_pem[myCA.pem]
    iot --> iot_out[outputs.tf]
    iot --> iot_vars[variables.tf]
    
    iot_modules --> iot_aws[aws_iot]
    
    %% ML module
    ml --> ml_api[apigateway]
    ml --> ml_dynamo[dynamodb]
    ml --> ml_iam[iam]
    ml --> ml_lambda[lambda]
    ml --> ml_main[main.tf]
    ml --> ml_out[outputs.tf]
    ml --> ml_s3[s3]
    ml --> ml_vars[variables.tf]
    
    %% User management module
    user --> user_lambda[lambda_functions]
    user --> user_main[main.tf]
    user --> user_modules[modules]
    user --> user_out[outputs.tf]
    user --> user_tfstate[terraform.tfstate]
    user --> user_tfbackup[terraform.tfstate.backup]
    user --> user_tfvars[terraform.tfvars]
    user --> user_vars[variables.tf]
    
    user_lambda --> user_admin[admin]
    user_lambda --> user_user[user]
    
    user_modules --> user_api[apigateway]
    user_modules --> user_cognito[cognito]
    user_modules --> user_dynamo[dynamodb]
    user_modules --> user_iam[iam]
    user_modules --> user_lambda_mod[lambda]
    user_modules --> user_waf[waf]
    ```