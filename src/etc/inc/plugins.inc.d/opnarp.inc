<?php

/*
 * Copyright (C) 2022 Michael Muenz <michael.muenz@max-it.de>
 * All rights reserved.
 *
 */

function opnarp_services()
{
    global $config;

    $services = array();

    if (isset($config['OPNsense']['opnarp']['general']['enabled']) && $config['OPNsense']['opnarp']['general']['enabled'] == 1) {
        $services[] = array(
            'description' => gettext('opnarp daemon'),
            'configd' => array(
                'restart' => array('opnarp restart'),
                'start' => array('opnarp start'),
                'stop' => array('opnarp stop'),
            ),
            'name' => 'OPNarp',
            'pidfile' => '/var/run/opnarp.pid',
        );
    }

    return $services;
}
