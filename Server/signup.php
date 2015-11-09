<?php
	require 'vendor/autoload.php';	
	
	session_start();
	
	date_default_timezone_set('Asia/Tokyo');

	use Parse\ParseClient;
	use Parse\ParseObject;
	use Parse\ParseQuery;
	use Parse\ParseACL;
// 	use Parse\ParsePush;
	use Parse\ParseUser;
// 	use Parse\ParseInstallation;
	use Parse\ParseException;
/*
	use Parse\ParseAnalytics;
	use Parse\ParseFile;
	use Parse\ParseCloud;
	use Parse\ParseSessionStorage;
*/	
	use Parse\ParseRole;
	use Parse\ParseRelation;
	use Parse\ParseConfig;


	use Ramsey\Uuid\Uuid;
	use Ramsey\Uuid\Exception\UnsatisfiedDependencyException;
	

	define('PARSE_APPLICATION_ID', '<YOUR_PARSE_APPLICATION_ID>' );
	define('PARSE_REST_API_KEY', '<YOUR_PARSE_REST_API_KEY>' );
	define('PARSE_MASTER_KEY', '<YOUR_PARSE_MASTER_KEY>' );

// 	$s_invitationid = 'F25D1889430D499396150B2EF15E3C12';
	$s_invitationid = htmlspecialchars($_GET['invitationid'], ENT_QUOTES);
	$s_method = htmlspecialchars($_POST['method'], ENT_QUOTES);
	$s_callbackid =  htmlspecialchars($_GET['callbackid'], ENT_QUOTES);

	$s_callback = htmlspecialchars($_GET['callback'], ENT_QUOTES);
		// コールバックを用意

// 	echo date('Y-m-d H:i:s', strtotime('-24 hour', time()));	
	if( PARSE_APPLICATION_ID == '<YOUR_PARSE_APPLICATION_ID>' || PARSE_REST_API_KEY == '<YOUR_PARSE_REST_API_KEY>' || PARSE_MASTER_KEY == '<YOUR_PARSE_MASTER_KEY>'){
		
        $response = new StdClass;
		if( PARSE_APPLICATION_ID == '<YOUR_PARSE_APPLICATION_ID>' ){
	        $response->errorDescription = "application ID empty.";
		}else if(PARSE_REST_API_KEY == '<YOUR_PARSE_REST_API_KEY>'){
	        $response->errorDescription = "REST API key empty.";
		}else if(PARSE_MASTER_KEY == '<YOUR_PARSE_MASTER_KEY>'){
	        $response->errorDescription = "master key empty.";
		}
        header('Content-type: application/json');
        echo stripslashes(json_encode($response));
	}else if( $s_method =='signup' ){
		ParseClient::initialize(PARSE_APPLICATION_ID,PARSE_REST_API_KEY,PARSE_MASTER_KEY);
		
		$email = $_SESSION['email'];
			// メールを取得
		$username = $_SESSION['username'];
			// メールを取得
			
		$s_passowrd = htmlspecialchars( $_POST['password']  ,ENT_QUOTES);
			// POSTから取得
		$key = $_SESSION['key'];
			// メールを取得
			
		try {
			$user = new ParseUser();
			$user->set("username", $username );
			$user->set("password", $s_passowrd );
			$user->set("email", $email );
			$user->signUp();
			
			
			$query = new ParseQuery('Invitation');
			$query->equalTo('UUID', $_SESSION['invitationID'] );
			$query->greaterThanOrEqualTo('createdAt',date('Y-m-d\TH:i:s.u', strtotime('-24 hour')) );
				// 24時間以内のオブジェクトに限る
			$invitation = $query->first();
			if( $invitation != NULL ){
				// オプションを登録
				$options = $invitation->get('options');
				$roleSchemes = $options['roles'];
				foreach ($roleSchemes as $roleScheme ){
					$roleName = $roleScheme['name'];
					$roleGenerateType = $roleScheme['generateType'];
/*					
					$roleRelationShips = $roleScheme['relationShips'];
*/
					
					// 既存のRoleに追加
					$saveRole = false;
					if( empty($roleName) != true ){
						$query = new ParseQuery("_Role");
						$query->equalTo('name', $roleName );
						$role = $query->first();
						if( $role != NULL ){
							if( $roleGenerateType != 'new' ){
								$role->getUsers()->add($user);
								$role->save();
							}
							$saveRole = true;
						}
					}
					
					if( $roleGenerateType != 'exist' && $saveRole != true ){
						// 新しくロールを追加
						if( empty($roleName) != true ){
							$roleACL = new ParseACL();
							$roleACL->setPublicWriteAccess(true);
							$roleACL->setPublicReadAccess(true);
							$role = ParseRole::createRole($roleName, $roleACL);
							$role->getUsers()->add($user);
							$role->save();
						}
					}					
				}

				$objectProperties = $options['properties'];
				foreach ($objectProperties as $objectPropertie ){
					$propertyName = $objectPropertie['name'];
					$queryClassName = $objectPropertie['className'];
					$queryObjectId = $objectPropertie['objectId'];
					$destination = $objectPropertie['destination'];
					
					if( empty($propertyName) != true && empty($queryClassName) != true && empty($queryObjectId) != true && empty($destination) != true){
						$query = new ParseQuery($queryClassName);
						$targetObject = $query->get($queryObjectId);
						if( $targetObject != NULL ){
							if( $destination == 'user' ){
								$user->set($propertyName, $targetObject );	
								$user->save();
							}else if( $destination == 'object' ){
								$targetObject->set($propertyName, $user );	
								$targetObject->	save();
							}
						}
					}
				}
				
				$relationShips = $options['relationShips'];
				foreach ($relationShips as $relationShip ){
					$propertyName = $relationShip['name'];
					$queryClassName = $relationShip['className'];
					$queryObjectId = $relationShip['objectId'];
					$destination = $objectPropertie['destination'];

					if( empty($propertyName) != true && empty($queryClassName) != true && empty($queryObjectId) != true && empty($destination) != true){
						$query = new ParseQuery($queryClassName);
						$targetObject = $query->get($queryObjectId);
						if( $targetObject != NULL ){
							if( $destination == 'user' ){
								$userRelations = $user->getRelation($propertyName);
								$userRelations->add($targetObject);
								$user->save();
							}else if( $destination == 'object' ){	
								$targetRelations = $targetObject->getRelation($propertyName);
								$targetRelations->add($user);
								$targetObject->save();
							}
						}
					}
				}
				
				// 招待オブジェクトを削除
				$invitation->destroy();
			}
			

			// 新しくUUIDを生成
			$UUID = Uuid::uuid1();
			$UUID = implode(explode( '-' , $UUID ));
			$invitationCallback = new ParseObject('InvitationCallback');
			$invitationCallback->set("username", $email );
			$invitationCallback->set('UUID', $UUID );
			$invitationCallback->save();
			
			$_SESSION['status'] = 'succeedAccount';
			$_SESSION['invitationID'] = $UUID;
			
			$config = new ParseConfig();
				// config を取得
			$_SESSION['loginURL'] = $config->get('IDPLoginScheme') . $UUID;
			echo file_get_contents('2_succeeded.html');	
			
			// ログアウト
			ParseUser::logOut();
		} catch (ParseException $ex) {
			if( $ex->getCode() == 202 ){
				$_SESSION['status'] = 'failureExistUser';
				$config = new ParseConfig();
					// config を取得
				$_SESSION['loginURL'] = $config->get('IDPLoginScheme');
				
				echo file_get_contents('3_failured.html');
			}else{
				// Show the error message somewhere and let the user try again.
				echo "Error: " . $ex->getCode() . " " . $ex->getMessage();
			}
		} catch (UnsatisfiedDependencyException $e) {
		    // Some dependency was not met. Either the method cannot be called on a
		    // 32-bit system, or it can, but it relies on Moontoast\Math to be present.
		    echo 'Caught exception: ' . $e->getMessage() . "\n";
		}
	
	}else if( empty($s_invitationid) != true ){
		ParseClient::initialize(PARSE_APPLICATION_ID,PARSE_REST_API_KEY,PARSE_MASTER_KEY);
				
		try {
			// 権限を確認
			$query = new ParseQuery('Invitation');
			$query->equalTo('UUID', $s_invitationid );
			$query->greaterThanOrEqualTo('createdAt',date('Y-m-d\TH:i:s.u', strtotime('-24 hour')) );
				// 24時間以内のオブジェクトに限る
			$invitation = $query->first();
				// Invitationオブジェクトを取得
			
			if( $invitation != NULL ){
				$_SESSION['invitationID'] = $invitation->get('UUID');
					// 招待IDを格納
				$_SESSION['email'] = $invitation->get('email');
				$_SESSION['username'] = $invitation->get('username');
				$_SESSION['status'] = 'createAccount';
				$_SESSION['key'] = $invitation->get('key');
				
				echo file_get_contents('1_signup.html');
			}else{
				//タイムアウト
				echo file_get_contents('3_failured.html');
			}
		} catch (ParseException $ex) {
		  // Show the error message somewhere and let the user try again.
		  echo "Error: " . $ex->getCode() . " " . $ex->getMessage();
		}
	}else if( empty($s_callbackid) != true ){
		ParseClient::initialize(PARSE_APPLICATION_ID,PARSE_REST_API_KEY,PARSE_MASTER_KEY);
		
		// 権限を確認
		$query = new ParseQuery('InvitationCallback');
		$query->equalTo('UUID', $s_callbackid );
		$query->greaterThanOrEqualTo('createdAt',date('Y-m-d\TH:i:s.u', strtotime('-24 hour')) );
			// 24時間以内のオブジェクトに限る
		$invitationCallback = $query->first();
		$username = $invitationCallback->get('username');
		$invitationCallback->destroy();
			// コールバックオブジェクトを削除
		
		$response = new StdClass;
		$response->username = $username;
			// ユーザー名のみ渡す

		header( 'Content-Type: application/json' );
		echo json_encode( $response );
	}else if( empty($s_callback) != true ){
		// アプリ内のセッション
		$response = new StdClass;
		$response->invitationID = $_SESSION['invitationID'];
		$response->email = $_SESSION['email'];
		$response->username = $_SESSION['username'];
		$response->status = $_SESSION['status'];
	
		if( empty($_SESSION['loginURL']) != true ){
			$response->loginURL = $_SESSION['loginURL'];	
		}
	
		header('content-type: application/javascript; charset=utf-8');
		echo $s_callback . '(' . json_encode($response) . ')';
	}else{
		echo file_get_contents('index.html');
	}

?>