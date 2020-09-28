*******************************
Task 4.2 – Use FAST via the API
*******************************

Step 1: Open Postman and go to the “4. F5 Application Services Templates (FAST)” in the “Collections” and select **“Step 4.2.1: GET FAST info”** and hit **‘Send’**.
Since FAST depends on AS3 you will see info about both.

.. image:: ../png/module4/task4_2_p1.png
    :align: center

(rest of output omitted)
Read through the response to understand what gets delivered.

Step 2: Select **“Step 4.2.2: GET FAST applications”** to show if any applications are deployed using FAST.
When you did not delete the FAST app deployment from the previous task, you should see this http-service showing up.

.. image:: ../png/module4/task4_2_p2.png
    :align: center

(rest of output omitted)

Step 3: To be able to deploy an application using FAST we need a template. 
In Postman, select **“Step 4.2.3: GET FAST templates”** and hit **‘Send’**.

.. image:: ../png/module4/task4_2_p3.png
    :align: center

Step 4: Copy “examples/simple_waf” from the response and paste it into the URI after /templates.
Like this: https://{{bigip_1_mgmt}}/mgmt/shared/fast/templates/examples/simple_waf and hit **‘Send’**.
The examples/simple_waf template layout is shown in the response. Scroll through to understand which options you can configure and pay special attention to the ‘required’ list.

.. image:: ../png/module4/task4_2_p4.png
    :align: center

Step 5: Before moving on with creating the template, FAST expects the WAF policy already to be present on the BIG-IP. So, first let’s install this policy by going into Postman and select “Step 4.2.4: Create local WAF policy” and check the URI and Body. This is not an AS3 nor a FAST-related REST call. Be aware that with all the ‘magic’ created by F5 automation toolchain, the BIG-IP still has a full functioning ‘Native’ iControl REST API. 
This request just creates a WAF policy which gets stored in the partition /Common.

.. image:: ../png/module4/task4_2_p5.png
    :align: center

Hit **‘Send’**.

Step 6: Now, based on the ‘required’ list a template has been created in the below section. Copy and paste it into the body of “Step 4.2.5: Deploy FAST simple_waf” and click ‘Send’.

.. code-block:: json

 {
    "name": "examples/simple_waf",
    "parameters": {
        "tenant_name": "Task4_2_FAST",
        "application_name": "waf-service",
        "virtual_port": 443,
        "virtual_address": "10.1.1.30",
        "WAF_policy_path": "/Common/base_waf_policy",
        "server_port": 80,
        "server_address": ["10.1.2.35"],
        "certificate": "-----BEGIN CERTIFICATE-----\nMIIDrjCCApagAwIBAgIEEDZqSTANBgkqhkiG9w0BAQsFADCBmDELMAkGA1UEBhMC\nVVMxCzAJBgNVBAgTAldBMRAwDgYDVQQHEwdTZWF0dGxlMRIwEAYDVQQKEwlNeUNv\nbXBhbnkxCzAJBgNVBAsTAklUMR4wHAYDVQQDExVsb2NhbGhvc3QubG9jYWxkb21h\naW4xKTAnBgkqhkiG9w0BCQEWGnJvb3RAbG9jYWxob3N0LmxvY2FsZG9tYWluMB4X\nDTE4MDgxNTEyMDAwOVoXDTI4MDgxMjEyMDAwOVowgZgxCzAJBgNVBAYTAlVTMQsw\nCQYDVQQIEwJXQTEQMA4GA1UEBxMHU2VhdHRsZTESMBAGA1UEChMJTXlDb21wYW55\nMQswCQYDVQQLEwJJVDEeMBwGA1UEAxMVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkw\nJwYJKoZIhvcNAQkBFhpyb290QGxvY2FsaG9zdC5sb2NhbGRvbWFpbjCCASIwDQYJ\nKoZIhvcNAQEBBQADggEPADCCAQoCggEBALhgsSNqnxeCYeiynxwPpUW379NE08aV\nHdR/RCNYbFlmXHtsIRWsTxt0pSNuK91b5MEY707zo/0lrW8QoINS74c6kKdeEByu\nOcaTrn8+VFF9i46J5/1TiTblag7QZfs/B1jZt4+VMwkcL3S3tqN/ffX6FF0tuNiW\nC8V+9l2NWqZg9hynR0mqwxSmyBRhewDtGcHHbW77q27yc4pb5Wr9nyJxUqlnqZMZ\n73T5WMyjpVZx/3qW0CuimpWKhTET5j4G7Vv9YGkABd33EULwcCLoRGBhZ7I7qORP\nJAIHvpt/AJyMTJXHhV7Krpn8cKZF3sgG6NVeuCbwvK3CEI5Q80QXQ4UCAwEAATAN\nBgkqhkiG9w0BAQsFAAOCAQEAX8kOXpXCP2josNyCE50YNB63SvMSOU9Mo21bkWKz\nEXmn+SYg+wx0RlvfcxUBjPolbVk1DZRBCB6xk5AjLJSDx+3Jz039K/Ypj4wcF+Ia\nLIHlkAEnT0eMsUsCPRXPnnRfyVER7+ER7TQUrWRhrw+9QYLmwFXlbLzDXwEX7Wb4\nLzjxfTZT5UoQsoE94XGScjeZJDdvDjpm1o3R5ag57MfxAFcS9rmW/tNs2xNYh3U8\nGzeJgpH4Rm8zRdWrVeq/AEyq0CwWZxRI1S3YrqjAc+nfpVQbC06yRGRLWlCKUZwf\npx+z/vcZaA9+e2LW3MafBNaEVcTXcOe0XOAx38AYWRCq7g==\n-----END CERTIFICATE-----\n",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC4YLEjap8XgmHo\nsp8cD6VFt+/TRNPGlR3Uf0QjWGxZZlx7bCEVrE8bdKUjbivdW+TBGO9O86P9Ja1v\nEKCDUu+HOpCnXhAcrjnGk65/PlRRfYuOief9U4k25WoO0GX7PwdY2bePlTMJHC90\nt7ajf331+hRdLbjYlgvFfvZdjVqmYPYcp0dJqsMUpsgUYXsA7RnBx21u+6tu8nOK\nW+Vq/Z8icVKpZ6mTGe90+VjMo6VWcf96ltAropqVioUxE+Y+Bu1b/WBpAAXd9xFC\n8HAi6ERgYWeyO6jkTyQCB76bfwCcjEyVx4Veyq6Z/HCmRd7IBujVXrgm8LytwhCO\nUPNEF0OFAgMBAAECggEAI6Mi0ezjm7RqjsLpsI+QmxlqnDwHL/C2D5LavXczmBMK\nKJv1iB4iOzUQTzkV9ubyX+VdKfY7OeycqWU+FSwEWq+18neipxyA09JLLdKDEy4w\nOYiLw+Hv2WG93mem8olT9vc7/N9yeh4NySJSRadYliD0ay8xdYGI/G8mGN5/yT0L\nUgj9lAHkA2UJDQlRzYFbZxF/eCWWZ6tosHraEwGKDdlqSkuZ62fQu5IoN97LIX2+\nxPZm6t+ROdUAURe2N4zhOperh3UYxmhTTzJTn/hOf6Lhb0VVbEHj5WjxKJVp3deH\nmBof5IZQxbm1iTzzLKP3ERwIpaaqlX+dIi9Q0pzhSQKBgQD4KqgHmkN1j8vikF3N\nseL8JqTveQd6AKPeB+TlWH/NWubpSK9f+EUQv+gN99u79GQg2N+gIiJclOlS0i0j\nY/xdIcpbFf7qQzaZlW0USi3nakrylnc7s3NNCWIEX/h5YsyxD/O1vwg570YXfEle\nASNLDiIz3w6wX/ebP7CpVjc3rQKBgQC+MpSlWsldSWrr3CvWMkC1bAc2n320A9oE\nlr/YPKgQ/1CRprplI+dF5liHxIHDnZqwnYTEYphitxj3RqTuppXu56FG3xmJWkVl\nkxivn+E4xahqLp9aaMRvFTTw/rVUYMzxLGU/3sTW6js/EcaI+u0PY9qKXDKJwv9Z\nYGGby28WOQKBgQCg8NkEBTFWnqj1B/ctnP291ToF7BHDN4MOTURO0HQhs6ApDnBd\n5t6znCFcXa/tVvNQshVk/n4WWKRwh8mqN//ETlOzerJVLr3MILIbBHh8qdxtMtOk\nrh5KiZk9iRfVcROaiOPerEMjf1+Pf5T9F/PRixr3VONr0vD7h/SD/VvWCQKBgQCU\nV8j+Cwgg/UEqgoeiQYGcvowFu3GEdLiXeahZlD2VPDzvzPV2KwGX0CfehJKdKpBb\nDhBeR3QJEjujqXK8PCuWsQxlxV4addDIf2jymaVE7U0EvCZHko0bApRPHqn5DKLr\nu6+gmDQ4V2osL8YEUomQxlXOMkisj+0vHXAj3hBfaQKBgQCNei4IMcCPCh/BSGgb\n9BUOYG0Y7856ca7nLo4x2G67NigGAp1EgvYW6i4wD/1zo7O/aF8UzYjTh7+BseO8\nZy3N+h6eajbzu6j3I3Sp+3TGGZcw/8s5EU2SPMl3Rf25wW0M33Xn0AwxGLzUY/dX\nNCffdM6CVXWk73y++Xahj5Aiiw==\n-----END PRIVATE KEY-----\n"
    }
 }


Step 7: Check the FAST deployed applications on the BIG-IP.

.. image:: ../png/module4/task4_2_p6.png
    :align: center

Check the deploy log and after this select the right partition and test if you have connection to the backend.

Step 8: To clean up what has been created by FAST. Go into the FAST template section and in the ‘Application List’ delete both FAST deployments.

This concludes FAST for this workshop. 
Be aware that FAST goes beyond this point by letting you create your own FAST templates. More details can be found here: https://clouddocs.f5.com/products/extensions/f5-appsvcs-templates/latest/userguide/template-authoring.html
