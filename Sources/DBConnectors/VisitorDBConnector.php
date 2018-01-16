<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-04T21:00:39+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T16:45:59+01:00


Namespace Sources\DBConnectors;

Use Orm;

class VisitorDBConnector extends MainDBConnector
{

	/** Username used to connect to DB */
	const USERNAME = 'postgres';

	/** Password used to connect to DB */
	const PASSWORD = '';

    /**
     * Constructor for the visitor database connector
     */
    public function __construct()
    {
		parent::__construct(self::USERNAME, self::PASSWORD);
    }

	/**
	 * Subscribes the given user to the website database
	 * @param  array	$user Informations about the user
	 * @return boolean	Return value of the subscribe function
	 */
	public function subscribeUser($user)
	{
		if (isset($user['last']) && isset($user['first']) && isset($user['birth']) && isset($user['phone']) && isset($user['mail']) && isset($user['pass']))
		{
			$stmt = $this->prepare('SELECT inscription_adherent(:last, :first, :birth, :phone, :mail, :pass)');
		    $stmt->setFetchMode(\PDO::FETCH_ASSOC);
		    $stmt->execute([
		        ':last' => $user['last'],
		        ':first' => $user['first'],
		        ':birth' => $user['birth'],
		        ':phone' => $user['phone'],
		        ':mail' => $user['mail'],
		        ':pass' => $user['pass']
		    ]);
		}
		return $stmt->fetchColumn();
	}

}
