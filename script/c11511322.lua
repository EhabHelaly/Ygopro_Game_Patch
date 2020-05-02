--Kairem Warrior Blade
function c11511322.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(c11511322.efilter))
	--equip from grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511322.eqcon)
	e1:SetOperation(c11511322.eqop)
	c:RegisterEffect(e1)
	--add to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11511322.con)
	e2:SetTarget(c11511322.tg)
	e2:SetOperation(c11511322.op)
	c:RegisterEffect(e2)
end

function c11511322.efilter(c)
	return c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM)
end

function c11511322.eqfilter(c,tp)
	return c:IsSetCard(0xffc) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c11511322.eqcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return eg:FilterCount(c11511322.eqfilter,nil,tp)==1
end
function c11511322.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:Filter(c11511322.eqfilter,nil,tp):GetFirst()
	if c and c:IsFaceup() then Duel.Equip(tp,e:GetHandler(),c) end
end

function c11511322.pfilter(c)
	return c:IsSetCard(0xffc) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c11511322.dfilter(c)
	return c:IsSetCard(0xffc) and c:IsAbleToHand()
end
function c11511322.con(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return e:GetHandler():GetEquipTarget()
end
function c11511322.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk ==0 then return Duel.IsExistingTarget(c11511322.pfilter,tp,LOCATION_SZONE,0,1,nil)
						and Duel.IsExistingMatchingCard(c11511322.dfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c11511322.pfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local g=Group.FromCards(e:GetHandler(),tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,0)
end
function c11511322.op(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetFirstTarget()
	if ec and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		local g=Group.FromCards(e:GetHandler(),tc)
		if Duel.Destroy(g,REASON_COST) then
			if Duel.CheckLocation(tp,LOCATION_SZONE,6) then
		    	Duel.MoveToField(ec,tp,tp,LOCATION_SZONE,POS_FACEUP,6)
		    else
		    	Duel.MoveToField(ec,tp,tp,LOCATION_SZONE,POS_FACEUP,7)
		    end

		    local g2=Duel.SelectMatchingCard(tp,c11511322.dfilter,tp,LOCATION_DECK,0,1,1,nil)
		    if g2:GetCount() then
		    	Duel.SendtoHand(g2,tp,REASON_EFFECT)
		    end
		end
	end
end

