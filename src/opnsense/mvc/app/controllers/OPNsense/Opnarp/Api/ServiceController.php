<?php

/*
 * Copyright (C) 2022 Michael Muenz <michael.muenz@max-it.de>
 * All rights reserved.
 */

namespace OPNsense\Opnarp\Api;

use OPNsense\Base\ApiMutableServiceControllerBase;
use OPNsense\Core\Backend;
use OPNsense\Opnarp\General;

class ServiceController extends ApiMutableServiceControllerBase
{
    protected static $internalServiceClass = '\OPNsense\Opnarp\General';
    protected static $internalServiceTemplate = 'OPNsense/Opnarp';
    protected static $internalServiceEnabled = 'enabled';
    protected static $internalServiceName = 'opnarp';

    /**
     * remove database folder
     * @return array
     */
    public function resetdbAction()
    {
        $backend = new Backend();
        $response = $backend->configdRun("opnarp resetdb");
        return array("response" => $response);
    }

}
