local unraid = import 'lib/unraid.libsonnet';

local appPort = '8582';
local network = 'proxynet';

local container = unraid.Container
    .withName('wavvy')
    .withRepository('markliederbach/wavvy')
    .withRegistry('https://hub.docker.com/r/markliederbach/wavvy')
    .withNetwork(network)
    .withPrivileged(false)
    .withSupport('https://github.com/markliederbach/wavvy/issues')
    .withProject('https://github.com/markliederbach/wavvy')
    .withOverview("Tiny Svelte app to show you the waveform for your voice.")
    .withCategory([
      'Tools:',
      'Productivity:',
      'Status:Beta',
    ])
    .withIcon('wavvy-logo')
    .withLogRotation()
    .withNetworking(
      network,
      [
        {
          hostPort: appPort,
          containerPort: '3000',
          protocol: 'tcp',
        },
      ]
    )
    .withWebUI(appPort, '/')
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
