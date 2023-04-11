local unraid = import 'lib/unraid.libsonnet';

local sharedDescription = "This agent periodically discovers the current host's external IP address, and updates a given DNS A record in Cloudflare with the value.";
local appPort = '8784';
local network = 'bridge';

local containerQrkDNS = unraid.Container
    .withName('qrkdns')
    .withRepository('markliederbach/qrkdns')
    .withRegistry('https://hub.docker.com/r/markliederbach/qrkdns')
    .withNetwork(network)
    .withPrivileged(false)
    .withSupport('https://github.com/markliederbach/qrkdns/issues')
    .withProject('https://github.com/markliederbach/qrkdns')
    .withOverview(sharedDescription)
    .withCategory([
      'HomeAutomation:',
      'Network:DNS',
      'Status:Beta',
    ])
    .withIcon('qrkdns-logo')
    .withLogRotation()
    .withPostArgs('sync cron')
    .withDescription(sharedDescription)
    .withNetworking(network, [])
    .withConfigVariables([
      {
        name: 'NETWORK_ID',
        description: 'Subdomain',
        required: true,
      },
      {
        name: 'DOMAIN_NAME',
        description: 'Base domain',
        required: true,
      },
      {
        name: 'CLOUDFLARE_ACCOUNT_ID',
        description: 'Cloudflare Account ID',
        required: true,
      },
      {
        name: 'CLOUDFLARE_API_TOKEN',
        description: 'Cloudflare API Token',
        required: true,
        mask: true,
      },
      {
        name: 'LOG_LEVEL',
        default: 'DEBUG',
        description: 'Container Log Level (default: DEBUG)',
        display: 'advanced',
      },
      {
        name: 'SCHEDULE',
        default: '*/30 * * * *',
        description: 'Cron Schedule (default every 30 minutes)',
        display: 'advanced',
      },
    ])

  ;
    // .withWebUI(appPort, '/')

{
  'qrkdns.xml': containerQrkDNS.toXML()
}
