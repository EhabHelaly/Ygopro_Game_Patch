--Infinity God Impact
function c11511604.initial_effect(c)
	c:SetUniqueOnField(1,0,11511604)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11511604.condition)
	e2:SetTarget(c11511604.target)
	e2:SetOperation(c11511604.operation)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetLabel(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e3:SetCost(c11511604.costSp)
	e3:SetTarget(c11511604.targetSp)
	e3:SetOperation(c11511604.operationSp)
	c:RegisterEffect(e3)
end

function c11511604.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()~=tp and c:GetPreviousControler()~=tp
end
function c11511604.condition(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return bit.band(r,REASON_DESTROY+REASON_EFFECT)==REASON_DESTROY+REASON_EFFECT 
	and re and re:GetHandler():IsAttribute(ATTRIBUTE_DEVINE) and re:GetHandler():IsControler(tp)
	and eg:FilterCount(c11511604.filter,nil,tp)>0
end
function c11511604.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local count = eg:FilterCount(c11511604.filter,nil,tp)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(count*1000)
	Duel.SetOperationInfo(nil,CATEGORY_DAMAGE,nil,nil,1-tp,count*1000)
end
function c11511604.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,dmg = Duel.GetChainInfo(nil,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,dmg,REASON_EFFECT)
end

function c11511604.filterR(c,code)
	return c:GetCode()==code and c:IsAbleToRemoveAsCost()
end
function c11511604.costSp(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c11511604.filterR,tp,LOCATION_GRAVE,0,1,nil,11511605)
		and Duel.IsExistingMatchingCard(c11511604.filterR,tp,LOCATION_GRAVE,0,1,nil,11511606)
		and Duel.IsExistingMatchingCard(c11511604.filterR,tp,LOCATION_GRAVE,0,1,nil,11511607)
	end
	local g=Group.FromCards(e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g:Merge( Duel.SelectMatchingCard(tp,c11511604.filterR,tp,LOCATION_GRAVE,0,1,1,nil,11511605) )
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g:Merge( Duel.SelectMatchingCard(tp,c11511604.filterR,tp,LOCATION_GRAVE,0,1,1,nil,11511606) )
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g:Merge( Duel.SelectMatchingCard(tp,c11511604.filterR,tp,LOCATION_GRAVE,0,1,1,nil,11511607) )
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_COST)
end
function c11511604.filterSp(c,e,tp,code)
	return c:GetCode()==code and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and not( c:IsLocation(LOCATION_GRAVE) and c:IsHasEffect(EFFECT_NECRO_VALLEY) )
end
function c11511604.targetSp(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(c11511604.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000020)
		and Duel.IsExistingMatchingCard(c11511604.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000010)
		and Duel.IsExistingMatchingCard(c11511604.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000000)
	end
end
function c11511604.operationSp(e,tp,eg,ep,ev,re,r,rp)
	if 	not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(c11511604.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000020)
		and Duel.IsExistingMatchingCard(c11511604.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000010)
		and Duel.IsExistingMatchingCard(c11511604.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000000)
	then
		local g=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge( Duel.SelectMatchingCard(tp,c11511604.filterSp,tp,e:GetLabel(),0,1,1,nil,e,tp,10000020) )
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge( Duel.SelectMatchingCard(tp,c11511604.filterSp,tp,e:GetLabel(),0,1,1,nil,e,tp,10000010) )
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge( Duel.SelectMatchingCard(tp,c11511604.filterSp,tp,e:GetLabel(),0,1,1,nil,e,tp,10000000) )
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)		
	end
end 

