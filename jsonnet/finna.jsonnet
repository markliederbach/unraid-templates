local unraid = import 'lib/unraid.libsonnet';

local appPort = '8784';
local network = 'proxynet';

local container = unraid.Container
    .withName('finna')
    .withRepository('markliederbach/finna-api')
    .withRegistry('https://hub.docker.com/r/markliederbach/finna-api')
    .withNetwork(network)
    .withPrivileged(false)
    .withSupport('https://github.com/markliederbach/finna/issues')
    .withProject('https://github.com/markliederbach/finna')
    .withOverview("Provides an easy way to Upload a Vanguard transaction report and receive a CSV file ready for import into Stock Events")
    .withCategory([
      'Tools:',
      'Productivity:',
      'Status:Beta',
    ])
    .withIcon('rocket')
    .withLogRotation()
    .withNetworking(
      network,
      [
        {
          hostPort: appPort,
          containerPort: appPort,
          protocol: 'tcp',
        },
      ]
    )
    .withWebUI(appPort, '/')
    .withConfigVariables([
      {
        name: 'BASE_URL',
        description: 'Unraid domain',
        required: true,
      },
      {
        name: 'LOG_LEVEL',
        default: 'DEBUG',
        description: 'Container Log Level (default: DEBUG)',
        display: 'advanced',
      },
    ])
    .withConfigPorts([
      {
        name: 'Web Interface Port',
        target: appPort,
        default: appPort,
        description: 'Port on the docker container for the web UI',
        display: 'advanced',
        required: true,
      },
    ])
  ;

{
  container:: container
}
