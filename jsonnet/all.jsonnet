local qrkdns = import 'qrkdns.jsonnet';
local finna = import 'finna.jsonnet';


{
  'qrkdns.xml': qrkdns.container.toXML(),
  'finna.xml': finna.container.toXML(),
}
