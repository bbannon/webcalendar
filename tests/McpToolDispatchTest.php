<?php

use PHPUnit\Framework\TestCase;

require_once __DIR__ . "/../includes/dbi4php.php";
require_once __DIR__ . "/../includes/functions.php";

/**
 * Verifies that mcp_dispatch_request() advertises the scheduling tools and
 * routes tools/call to the right WebCalendarMcpTools method with the right
 * arguments. A stub $tools object records the call, so this exercises the
 * dispatch wiring without loading mcp.php's transport bootstrap.
 */
final class McpToolDispatchTest extends TestCase
{
  private function stubTools() {
    return new class {
      public $calls = [];
      public function get_availability($start_date, $end_date) {
        $this->calls[] = ['get_availability', [$start_date, $end_date]];
        return ['busy' => [], 'all_day' => [], 'timezone' => 'GMT'];
      }
      public function check_conflicts($date, $time, $duration) {
        $this->calls[] = ['check_conflicts', [$date, $time, $duration]];
        return ['has_conflict' => false, 'conflicts' => []];
      }
    };
  }

  private function call($tools, $name, $arguments) {
    return mcp_dispatch_request([
      'jsonrpc' => '2.0',
      'method' => 'tools/call',
      'params' => ['name' => $name, 'arguments' => $arguments],
      'id' => 1,
    ], $tools);
  }

  // --- schema advertising -------------------------------------------------

  public function test_get_availability_schema_required_fields() {
    $schema = get_mcp_tool_schema('get_availability');
    $this->assertNotNull($schema);
    $this->assertContains('start_date', $schema['required']);
    $this->assertContains('end_date', $schema['required']);
  }

  public function test_check_conflicts_schema_required_fields() {
    $schema = get_mcp_tool_schema('check_conflicts');
    $this->assertNotNull($schema);
    $this->assertContains('date', $schema['required']);
    $this->assertContains('time', $schema['required']);
    $this->assertContains('duration', $schema['required']);
  }

  // --- routing ------------------------------------------------------------

  public function test_dispatch_routes_get_availability_with_args() {
    $tools = $this->stubTools();
    $resp = $this->call($tools, 'get_availability',
      ['start_date' => '20260101', 'end_date' => '20260131']);

    $this->assertSame(['get_availability', ['20260101', '20260131']], $tools->calls[0]);
    $this->assertArrayHasKey('result', $resp);
    $this->assertArrayNotHasKey('error', $resp);
  }

  public function test_dispatch_routes_check_conflicts_with_args() {
    $tools = $this->stubTools();
    $resp = $this->call($tools, 'check_conflicts',
      ['date' => '20260611', 'time' => '090000', 'duration' => 60]);

    $this->assertSame(['check_conflicts', ['20260611', '090000', 60]], $tools->calls[0]);
    $this->assertArrayHasKey('result', $resp);
    $this->assertFalse($resp['result']['has_conflict']);
  }
}
