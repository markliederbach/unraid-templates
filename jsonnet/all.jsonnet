local qrkdns = import 'qrkdns.jsonnet';
local finna = import 'finna.jsonnet';
local wavvy = import 'wavvy.jsonnet';


{
  'qrkdns.xml': qrkdns.container.toXML(),
  'finna.xml': finna.container.toXML(),
  'wavvy.xml': wavvy.container.toXML(),
}
