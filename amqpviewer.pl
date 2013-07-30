#!/usr/bin/perl

use strict;
use Net::RabbitMQ;
use Getopt::Long;

my %options;
$options{'amqp_host'} = '127.0.0.1';
$options{'amqp_port'} = 5672;
$options{'amqp_user'} = 'guest';
$options{'amqp_password'} = 'guest';
$options{'amqp_vhost'} = '/';
$options{'amqp_exchange'} = 'exchange';
$options{'amqp_queue'} = 'amqpviewerqueue';
$options{'amqp_topic'} = '';

GetOptions ("var=s" => \%options);

my $mq = Net::RabbitMQ->new();
$mq->connect($options{'amqp_host'} , { port => $options{'amqp_port'}, user => $options{'amqp_user'}, password => $options{'amqp_password'}, vhost => $options{'amqp_vhost'} });
$mq->channel_open(1);
$mq->queue_declare(1, $options{'amqp_queue'});
$mq->queue_bind(1, $options{'amqp_queue'}, $options{'amqp_exchange'}, $options{'amqp_topic'});
$mq->consume(1,$options{'amqp_queue'});

while(1) {
  my $msg = $mq->recv();
  if ($msg) {
    print $msg->{'body'},"\n";
  } else {
    sleep(1);
  }
}
