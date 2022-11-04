<?php
namespace OCA\MFAChecker\Controller;

use OCP\IRequest;
use OCP\AppFramework\Http\TemplateResponse;
use OCP\AppFramework\Http\DataResponse;
use OCP\AppFramework\Controller;
use OCP\ISession;

class PageController extends Controller {
	private $userId;
	private UserData $userData;
	private ISession $session;
	public function __construct($AppName, IRequest $request, ISession $session, $UserId){
		parent::__construct($AppName, $request);
		$this->session = $session;
		$this->userId = $UserId;
	}

	/**
	 * CAUTION: the @Stuff turns off security checks; for this page no admin is
	 *          required and no CSRF check. If you don't know what CSRF is, read
	 *          it up in the docs or you might create a security hole. This is
	 *          basically the only required method to add this exemption, don't
	 *          add it to any other method if you don't exactly know what it does
	 *
	 * @NoAdminRequired
	 * @NoCSRFRequired
	 */
	public function index() {
		$user =[];
		$result = [];
		if (!empty($this->session->get('globalScale.UserData'))) {
			$attr = $this->session->get('globalScale.UserData')["userData"];
			$result["isGssAuthenticated"] = true;
			$result["displayName"] = $attr["displayName"];
			$result["username"] = $attr["uid"];
			$result["mfaVerified"] = $attr["mfaVerified"];
			$result["local_tfa"] = false;
			$result["isSamlAuthenticated"] = false;
		}
		if (!empty($this->session->get('user_saml.samlUserData'))) {
			$attr = $this->session->get('user_saml.samlUserData');
			$result["isSamlAuthenticated"] = true;
			$result["displayName"] = $attr["display_name"][0];
			$result["username"] = $attr["username"][0];
			$result["mfaVerified"] = $attr["mfa_verified"][0];

		}
		if (!empty($this->session->get("two_factor_auth_passed"))){
			$result["local_tfa"] = true;
			$result["mfaVerified"] = $user["mfa_verified"][0];
		}
		return new TemplateResponse('mfachecker', 'index', $result );  // templates/index.php
	}

}
