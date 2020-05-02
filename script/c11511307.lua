-- Kairem Omega
function c11511307.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- Change Scale (Normal Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c11511307.tg1)
	e1:SetOperation(c11511307.op1)
	c:RegisterEffect(e1)
	-- destroy cards (Pendulum Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11511307.conP)
	e2:SetTarget(c11511307.tg2)
	e2:SetOperation(c11511307.op2)
	c:RegisterEffect(e2)
	-- cannot attack (Pendulum effect)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_MAIN_END+TIMING_BATTLE_PHASE)
	e3:SetCondition(c11511307.con3)
	e3:SetTarget(c11511307.tg3)
	e3:SetOperation(c11511307.op3)
	c:RegisterEffect(e3)
	-- Pendulum Summon Counter 
	if not c11511307.global_check then
		c11511307.global_check=true
		c11511307[0]=0
		c11511307[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c11511307.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c11511307.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c11511307.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and tc:IsSetCard(0xffc) then
			local p=tc:GetSummonPlayer()
			c11511307[p]=c11511307[p]+1
		end
		tc=eg:GetNext()
	end
end
function c11511307.clearop(e,tp,eg,ep,ev,re,r,rp)
	c11511307[0]=0
	c11511307[1]=0
end

function c11511307.con3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return tp~=Duel.GetTurnPlayer() and bit.band(ph,PHASE_MAIN2+PHASE_END)==0
end
function c11511307.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c11511307.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
end
function c11511307.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc)
end
function c11511307.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511307.filter1,tp,LOCATION_PZONE,0,1,nil) end
end
function c11511307.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11511307.filter1,tp,LOCATION_PZONE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local value=1
		if tc:GetLeftScale()>0 and tc:GetRightScale()>0 then
			value=Duel.SelectOption(tp,aux.Stringid(11511312,0),aux.Stringid(11511312,1))*-2+1
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end
function c11511307.conP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c11511307.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c11511307[tp],nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11511307.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
