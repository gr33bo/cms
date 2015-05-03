require 'torquebox-web'
#require 'elasticsearch'





#topic = TorqueBox::Messaging.topic('browser-messages')

#TorqueBox::Web.server.sockjs(:path => '/messages').on_connection do |sockjs_conn|
#  # write any messages from the topic to this sockjs connection
#  msg_listener = topic.listen do |message|
#    sockjs_conn.write(message)
#  end
#
#  # write any messages from the browser to the topic
#  sockjs_conn.on_data do |data_from_browser|
##    topic.publish(data_from_browser)
#  end
#
#  # clean up resources when browser disconnects
#  sockjs_conn.on_close do
#    msg_listener.close
#  end
#
#  # write a welcome message to the browser
#  sockjs_conn.write("Welcome!")
#end
