DECLARE
   req         UTL_HTTP.req;
   res         UTL_HTTP.resp;
   url         VARCHAR2 (4000)
                       := 'https://workspace.slack.com//api/chat.postMessage';
                     --The slack api can be replaced based on the requirement
   NAME        VARCHAR2 (4000);
   v_buffer    VARCHAR2 (4000);
   v_content   VARCHAR2 (4000)
      := '{"channel":"your-channel-name-here","username":"bot-name","icon_emoji":"bot-logo","link_names":"true","text":"your-message-here"}';
BEGIN
   UTL_HTTP.set_wallet ('file:/u01/oradev/DEV/12.1.0/wallet', NULL);
   req := UTL_HTTP.begin_request (url, 'POST', 'HTTP/1.1');
   UTL_HTTP.set_header (req,
                        'Authorization',
                        'Bearer <your-slack-token-here>'
                       );
   UTL_HTTP.set_header (req, 'Content-Type', 'application/json');
   UTL_HTTP.set_header (req, 'Content-Length', LENGTH (v_content));
   UTL_HTTP.write_text (req, v_content);
   res := UTL_HTTP.get_response (req);
   DBMS_OUTPUT.put_line (req.url);
   DBMS_OUTPUT.put_line (req.method);
   DBMS_OUTPUT.put_line (req.http_version);

   -- process the response from the HTTP call
   BEGIN
      LOOP
         UTL_HTTP.read_line (res, v_buffer);
         DBMS_OUTPUT.put_line (v_buffer);
      END LOOP;

      UTL_HTTP.end_response (res);
   EXCEPTION
      WHEN UTL_HTTP.end_of_body
      THEN
         UTL_HTTP.end_response (res);
   END;
END;