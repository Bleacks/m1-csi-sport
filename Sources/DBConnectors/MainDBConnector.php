<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-04T21:00:39+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T16:46:31+01:00


Namespace Sources\DBConnectors;

Use Orm;

abstract class MainDBConnector extends \PDO
{

	private static $instances = array(
		'Visitor'	=> Null,
		'Unpayed'	=> Null,
		'User'		=> Null,
		'Coach'		=> Null,
		'Employee'	=> Null,
		'Admin'		=> Null
	);

	/** Type definition for PostgreSQL Database */
    const FIELDS_LENGTH = array(
        'TableName'         => array(
            'Champ'         => "[String length]"
        )
    );

	/** Database hostname in PostgreSQL */
	const DB_HOST = 'localhost';

	/** Database port in PostgreSQL */
	const DB_PORT = '5432';

	/** Database name in PostgreSQL */
	const DB_NAME = 'csi-sport';

    /**
     * Super constructor for every connector
     * @param string $username Username to connect database user
     * @param string $password Password for the given username
     */
    public function __construct($user, $pass)
    {
		$conStr = sprintf("pgsql:host=%s;port=%s;dbname=%s;user=%s;password=%s",
				self::DB_HOST,
				self::DB_PORT,
				self::DB_NAME,
				$user,
				$pass
			);
		parent::__construct($conStr);
		$this->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
    }

	/**
     * Used to retrieve the unique instance of Connector for this right level (Singleton)
     * @return MainDBConnector Singleton
     */
    public static function getInstance($rightLevel = 'Visitor')
    {
		$connector = false;
		foreach (self::$instances as $right => $conn) {
			if ($right == $rightLevel)
			{
				if (isset($conn))
				{
					$connector = $conn;
				}
				else {
					$connector = self::createConnector($right);
					self::$instances[$right] = $connector;
				}
			}
		}
		return $connector;
	}

	/**
	 * Creates a connector for the given level of right
	 * @param  string $right right of the current user
	 * @return MainDBConnector	Connector to the database with the given rights
	 */
	private static function createConnector($right)
	{
		switch($right)
		{
			case 'Visitor':
				$connector = new VisitorDBConnector();
				break;

			case 'Unpayed':
				break;

			case 'User':
				break;

			case 'Coach':
				break;

			case 'Employee':
				break;

			case 'Admin':
				break;

			default:
				var_dump('Error, right level not found');
				break;
		}
		return $connector;
	}

}
